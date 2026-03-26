#!/bin/bash
# 小塔世界 v2.1.1 双 XP 系统 - 一键部署脚本

echo "🚀 开始部署 小塔世界 v2.1.1..."
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

# 从 GitHub 下载最新代码
echo "📥 下载最新代码..."
curl -sL https://raw.githubusercontent.com/kzredpapa/xta-game2/master/index.html -o /tmp/xta-game-v2.1.1.html

# 检查文件大小
if [ $(stat -c%s /tmp/xta-game-v2.1.1.html 2>/dev/null || stat -f%z /tmp/xta-game-v2.1.1.html 2>/dev/null) -lt 1000 ]; then
    echo "❌ 下载失败，文件太小"
    exit 1
fi

echo "✅ 下载成功 ($(wc -c < /tmp/xta-game-v2.1.1.html) bytes)"

# 备份旧版本
echo "💾 备份旧版本..."
if [ -f /usr/share/nginx/html/index.html ]; then
    sudo cp /usr/share/nginx/html/index.html /usr/share/nginx/html/index.html.bak.$(date +%Y%m%d%H%M%S)
    echo "✅ 备份完成"
fi

# 复制到 Nginx 目录
echo "📁 部署新版本..."
sudo cp /tmp/xta-game-v2.1.1.html /usr/share/nginx/html/index.html

# 重启 Nginx
echo "🔄 重启 Nginx..."
sudo systemctl restart nginx

# 检查状态
if sudo systemctl status nginx | grep -q "active (running)"; then
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "✅ v2.1.1 部署完成！"
    echo "🌐 访问地址：http://114.215.210.41"
    echo ""
    echo "📋 版本特性:"
    echo "   • 等级 XP 永久累计"
    echo "   • 每日 XP 兑换 SC"
    echo "   • 双 XP 系统上线"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
else
    echo "❌ Nginx 启动失败，请检查日志"
    sudo systemctl status nginx
    exit 1
fi

# 清理临时文件
rm -f /tmp/xta-game-v2.1.1.html
