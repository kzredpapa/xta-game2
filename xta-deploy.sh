#!/bin/bash
# /opt/scripts/xta-deploy.sh
# 小塔世界维护脚本

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LOG_FILE="/var/log/xta-deploy.log"
WEB_ROOT="/usr/share/nginx/html"
BACKUP_DIR="/var/backups/xta-game"
GITHUB_REPO="https://raw.githubusercontent.com/kzredpapa/xta-game2/master/index.html"

# 日志函数
log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a "$LOG_FILE"
}

# 部署函数
do_deploy() {
    log "=== 开始部署小塔世界 ==="
    
    # 1. 备份旧文件
    BACKUP_FILE="$BACKUP_DIR/index.html.bak.$(date +%Y%m%d%H%M%S)"
    mkdir -p "$BACKUP_DIR"
    cp "$WEB_ROOT/index.html" "$BACKUP_FILE"
    log "✅ 备份至：$BACKUP_FILE"
    
    # 2. 下载新版本
    log "📥 从 GitHub 下载..."
    curl -sL "$GITHUB_REPO?t=$(date +%s)" -o "$WEB_ROOT/index.html"
    
    # 3. 验证文件
    if [ ! -f "$WEB_ROOT/index.html" ]; then
        log "❌ 下载失败，恢复备份"
        cp "$BACKUP_FILE" "$WEB_ROOT/index.html"
        exit 1
    fi
    
    FILE_SIZE=$(stat -c%s "$WEB_ROOT/index.html")
    if [ "$FILE_SIZE" -lt 1000 ]; then
        log "❌ 文件太小 ($FILE_SIZE bytes)，恢复备份"
        cp "$BACKUP_FILE" "$WEB_ROOT/index.html"
        exit 1
    fi
    
    log "✅ 下载完成 ($FILE_SIZE bytes)"
    
    # 4. 验证版本
    VERSION=$(grep -o "v2\.[0-9]\.[0-9]" "$WEB_ROOT/index.html" | head -1)
    log "📋 检测到版本：$VERSION"
    
    # 5. 重启 Nginx
    log "🔄 重启 Nginx..."
    systemctl restart nginx
    
    # 6. 验证服务
    sleep 2
    if systemctl is-active --quiet nginx; then
        log "✅ Nginx 运行正常"
    else
        log "❌ Nginx 启动失败，恢复备份"
        cp "$BACKUP_FILE" "$WEB_ROOT/index.html"
        systemctl restart nginx
        exit 1
    fi
    
    # 7. 本地验证
    LOCAL_VERSION=$(curl -s http://127.0.0.1/index.html | grep -o "v2\.[0-9]\.[0-9]" | head -1)
    log "📍 本地版本：$LOCAL_VERSION"
    
    if [ "$LOCAL_VERSION" != "$VERSION" ]; then
        log "❌ 本地验证失败"
        exit 1
    fi
    
    log "✅ 部署完成！版本：$VERSION"
    log "🌐 访问地址：http://114.215.210.41"
    log "⚠️  CDN 缓存可能需要 10-30 分钟刷新"
    
    exit 0
}

# 状态检查
do_status() {
    log "=== 小塔世界状态 ==="
    echo "Nginx 状态："
    systemctl status nginx --no-pager | head -5
    echo ""
    echo "当前版本："
    grep -o "v2\.[0-9]\.[0-9]" "$WEB_ROOT/index.html" | head -1
    echo ""
    echo "文件大小："
    ls -lh "$WEB_ROOT/index.html"
    echo ""
    echo "最近备份："
    ls -lt "$BACKUP_DIR"/*.bak.* 2>/dev/null | head -3
}

# 查看日志
do_logs() {
    LINES=${1:-50}
    tail -n "$LINES" "$LOG_FILE"
}

# 清理旧备份（保留最近 5 个）
do_cleanup() {
    log "🧹 清理旧备份..."
    cd "$BACKUP_DIR" && ls -t *.bak.* 2>/dev/null | tail -n +6 | xargs rm -f
    log "✅ 清理完成"
}

# 主函数
case "$1" in
    deploy)
        do_deploy
        ;;
    status)
        do_status
        ;;
    logs)
        do_logs "$2"
        ;;
    cleanup)
        do_cleanup
        ;;
    *)
        echo "用法：$0 {deploy|status|logs [行数]|cleanup}"
        echo ""
        echo "命令说明："
        echo "  deploy   - 部署最新版本"
        echo "  status   - 查看当前状态"
        echo "  logs     - 查看部署日志"
        echo "  cleanup  - 清理旧备份（保留最近 5 个）"
        exit 1
        ;;
esac
