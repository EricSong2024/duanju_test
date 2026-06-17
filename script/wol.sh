#!/bin/bash
# ============================================================================
#  WOL 唤醒 + Windows 在线检查
#
#  用法：
#    wol.sh            # 发送魔术包 + 等待 Windows 上线
#    wol.sh wake       # 同上
#    wol.sh check      # 只检查是否在线（不唤醒）
#    wol.sh wait       # 等待 Windows 上线（最多 90s）
#
#  退出码：
#    0 = Windows 在线
#    1 = Windows 不在线
# ============================================================================

WIN_MAC="B4:2E:99:4B:B7:02"
BROADCAST_IP="192.168.0.255"
WIN_IP="192.168.0.2"
WAIT_TIMEOUT=90

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LOCAL_LOG="$SCRIPT_DIR/wol.log"

log() { echo "[$(date '+%H:%M:%S')] $*" | tee -a "$LOCAL_LOG"; }

# ---------- 子命令：check ----------
cmd_check() {
    if ping -c 1 -W 2 "$WIN_IP" &> /dev/null; then
        echo "✅ Windows 在线 ($WIN_IP)"
        return 0
    else
        echo "❌ Windows 不在线 ($WIN_IP 不通)"
        return 1
    fi
}

# ---------- 子命令：wait ----------
cmd_wait() {
    log "等待 Windows 上线（最多 ${WAIT_TIMEOUT}s）..."
    elapsed=0
    while [ $elapsed -lt $WAIT_TIMEOUT ]; do
        sleep 5
        elapsed=$((elapsed + 5))
        if ping -c 1 -W 2 "$WIN_IP" &> /dev/null; then
            log "✅ Windows 已上线 (用时 ${elapsed}s)"
            return 0
        fi
        printf "."
    done
    echo ""
    log "❌ ${WAIT_TIMEOUT}s 内未上线"
    return 1
}

# ---------- 子命令：wake ----------
cmd_wake() {
    log "===== WOL 唤醒 Windows ====="
    log "MAC      : $WIN_MAC"
    log "广播地址 : $BROADCAST_IP"
    log "目标 IP  : $WIN_IP"

    if ! command -v wakeonlan &> /dev/null; then
        log "❌ wakeonlan 未安装，请先：brew install wakeonlan"
        return 1
    fi

    # 先检查是否已在线
    if ping -c 1 -W 2 "$WIN_IP" &> /dev/null; then
        log "Windows 已经在跑，无需唤醒"
        return 0
    fi

    log "📡 发送魔术包 ..."
    wakeonlan -i "$BROADCAST_IP" "$WIN_MAC"
    if [ $? -ne 0 ]; then
        log "❌ 发送失败"
        return 1
    fi
    log "✅ 魔术包已发送"

    cmd_wait
}

# ---------- 入口 ----------
case "${1:-wake}" in
    check)
        cmd_check
        ;;
    wait)
        cmd_wait
        ;;
    wake|"")
        cmd_wake
        ;;
    *)
        echo "用法: $0 {wake|check|wait}"
        echo "  wake  (默认) 发送 WOL 魔术包 + 等待上线"
        echo "  check         只检查是否在线"
        echo "  wait          只等待上线（不发魔术包）"
        exit 1
        ;;
esac
