#!/bin/bash
# 小塔世界 v2.1.3 紧急部署 - 强制刷新

echo "🚀 强制部署 小塔世界 v2.1.3..."
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

# 从 GitHub 下载最新代码
echo "📥 下载最新代码..."
curl -sL https://raw.githubusercontent.com/kzredpapa/xta-game2/master/index.html -o /tmp/xta-game-v2.1.3.html

# 检查文件大小
SIZE=$(stat -c%s /tmp/xta-game-v2.1.3.html 2>/dev/null || stat -f%z /tmp/xta-game-v2.1.3.html 2>/dev/null)
if [ "$SIZE" -lt 1000 ]; then
    echo "❌ 下载失败，文件太小 ($SIZE bytes)"
    exit 1
fi

echo "✅ 下载成功 ($SIZE bytes)"

# 备份旧版本
echo "💾 备份旧版本..."
TIMESTAMP=$(date +%Y%m%d%H%M%S)
if [ -f /usr/share/nginx/html/index.html ]; then
    sudo cp /usr/share/nginx/html/index.html /usr/share/nginx/html/index.html.bak.$TIMESTAMP
    echo "✅ 备份完成：index.html.bak.$TIMESTAMP"
fi

# 强制覆盖新版本
echo "📁 部署新版本..."
sudo cp /tmp/xta-game-v2.1.3.html /usr/share/nginx/html/index.html

# 清理浏览器缓存（添加版本号）
echo "🧹 清理缓存..."
sudo rm -rf /var/cache/nginx/* 2>/dev/null || true

# 重启 Nginx
echo "🔄 重启 Nginx..."
sudo systemctl restart nginx

# 检查状态
if sudo systemctl status nginx | grep -q "active (running)"; then
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "✅ v2.1.3 部署完成！"
    echo "🌐 访问地址：http://114.215.210.41"
    echo ""
    echo "📋 版本特性:"
    echo "   • 文案统一：当日 XP / 累积 XP"
    echo "   • 🎒 道具背包快捷栏"
    echo "   • ⏱️ 时间暂停器：50 累积 XP"
    echo "   • 💆 睡前按摩券：50 当日 XP"
    echo ""
    echo "⚠️  如果页面还是旧的，请强制刷新浏览器:"
    echo "   • Chrome/Edge: Ctrl+F5 或 Cmd+Shift+R"
    echo "   • Safari: Cmd+Option+R"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
else
    echo "❌ Nginx 启动失败，请检查日志"
    sudo systemctl status nginx
    exit 1
fi

# 清理临时文件
rm -f /tmp/xta-game-v2.1.3.html
