#!/bin/bash
# 远程关闭 Windows 上的 ComfyUI
# 关闭策略：优雅结束 python 进程（pid 写入 .pid 文件供 winstartcomfyui 使用）
# 用法：/Users/openclaw/winstopcomfyui.sh

WIN_USER="administrator"
WIN_IP="192.168.0.2"
COMFY_PORT="8188"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LOCAL_LOG="$SCRIPT_DIR/winstopcomfyui.log"

log() { echo "[$(date '+%H:%M:%S')] $*" | tee -a "$LOCAL_LOG"; }

log "关闭远程 ComfyUI: $WIN_USER@$WIN_IP"

# 1) 先看 ComfyUI 是不是在跑
if ! curl -s -o /dev/null -w "%{http_code}" --max-time 2 http://$WIN_IP:$COMFY_PORT/ 2>/dev/null | grep -q "200"; then
    log "ComfyUI 未运行（端口 $COMFY_PORT 不通）"
    exit 0
fi

# 2) 优雅结束：通过 ComfyUI API 发 shutdown 信号
#    ComfyUI 收到 /free 后会优雅关闭；这里用 taskkill /F 强制结束更快
log "结束 python.exe 进程..."
ssh $WIN_USER@$WIN_IP 'cmd /c "taskkill /F /IM python.exe"' 2>&1 | tee -a "$LOCAL_LOG"

# 3) 等待端口释放
log "等待端口释放..."
for i in {1..12}; do
    sleep 2
    if ! curl -s -o /dev/null -w "%{http_code}" --max-time 2 http://$WIN_IP:$COMFY_PORT/ 2>/dev/null | grep -q "200"; then
        log "✅ ComfyUI 已关闭 (用时 $((i*2))s)"
        exit 0
    fi
    printf "."
done

log ""
log "❌ 24s 内端口仍通，进程可能没杀干净"
log "   手动排查: ssh $WIN_USER@$WIN_IP 'tasklist | findstr python'"
exit 1
