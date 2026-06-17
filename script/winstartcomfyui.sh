#!/bin/bash
# 远程启动 Windows 上的 ComfyUI
# 前提：bat 中 pause 已删除
# 用法：/Users/openclaw/winstartcomfyui.sh

WIN_USER="administrator"
WIN_IP="192.168.0.2"
COMFY_PORT="8188"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LOCAL_LOG="$SCRIPT_DIR/winstartcomfyui.log"

log() { echo "[$(date '+%H:%M:%S')] $*" | tee -a "$LOCAL_LOG"; }

log "启动远程 ComfyUI: $WIN_USER@$WIN_IP"

# 已在线跳过
if curl -s -o /dev/null -w "%{http_code}" --max-time 2 http://$WIN_IP:$COMFY_PORT/ 2>/dev/null | grep -q "200"; then
    log "ComfyUI 已在运行"
    exit 0
fi

# ssh -f 立即返回，python 在 Windows 端独立跑（SSH 断不影响）
ssh -f $WIN_USER@$WIN_IP "cd /d E:\\ComfyUI && run_nvidia_gpu_fast_fp16_accumulation.bat"

# 轮询端口
log "等待启动..."
for i in {1..18}; do
    sleep 5
    if curl -s -o /dev/null -w "%{http_code}" --max-time 2 http://$WIN_IP:$COMFY_PORT/ 2>/dev/null | grep -q "200"; then
        log "✅ 已上线 (用时 $((i*5))s) http://$WIN_IP:$COMFY_PORT/"
        exit 0
    fi
    printf "."
done

log ""
log "❌ 90s 未启动"
exit 1
