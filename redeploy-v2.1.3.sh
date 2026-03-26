#!/bin/bash
# 小塔世界 v2.1.3 重新发布脚本
# 假设之前的发布不存在，完全重新部署

set -e

echo "========================================"
echo "🚀 小塔世界 v2.1.3 重新发布"
echo "========================================"
echo ""

# 1. 备份当前文件
echo "📦 备份当前文件..."
BACKUP_FILE="/usr/share/nginx/html/index.html.bak.$(date +%Y%m%d%H%M%S)"
sudo cp /usr/share/nginx/html/index.html $BACKUP_FILE 2>/dev/null || echo "⚠️  无文件可备份"
echo "✅ 备份至：$BACKUP_FILE"
echo ""

# 2. 删除旧文件
echo "🗑️  删除旧文件..."
sudo rm -f /usr/share/nginx/html/index.html
echo "✅ 已删除"
echo ""

# 3. 等待 Nginx 检测到文件消失
echo "⏳ 等待 5 秒..."
sleep 5
echo ""

# 4. 从 GitHub 重新下载
echo "📥 从 GitHub 下载最新代码..."
sudo curl -sL "https://raw.githubusercontent.com/kzredpapa/xta-game2/master/index.html?redeploy=$(date +%s)" -o /usr/share/nginx/html/index.html
echo "✅ 下载完成"
echo ""

# 5. 验证下载
echo "🔍 验证文件..."
FILE_SIZE=$(stat -c%s /usr/share/nginx/html/index.html 2>/dev/null || stat -f%z /usr/share/nginx/html/index.html 2>/dev/null)
echo "文件大小：$FILE_SIZE bytes"

if [ "$FILE_SIZE" -lt 1000 ]; then
    echo "❌ 文件太小，下载可能失败"
    echo "🔄 恢复备份..."
    sudo cp $BACKUP_FILE /usr/share/nginx/html/index.html
    exit 1
fi

VERSION=$(grep -o "v2\.[0-9]\.[0-9]" /usr/share/nginx/html/index.html | head -1)
echo "版本号：$VERSION"

if [ "$VERSION" != "v2.1.3" ]; then
    echo "❌ 版本不正确，期望 v2.1.3，实际：$VERSION"
    echo "🔄 恢复备份..."
    sudo cp $BACKUP_FILE /usr/share/nginx/html/index.html
    exit 1
fi

FEATURES=$(grep -c "当日 XP\|累积 XP\|道具背包" /usr/share/nginx/html/index.html || echo "0")
echo "v2.1.3 特征匹配：$FEATURES 处"

if [ "$FEATURES" -lt 10 ]; then
    echo "❌ 特征匹配不足，可能下载了旧版本"
    echo "🔄 恢复备份..."
    sudo cp $BACKUP_FILE /usr/share/nginx/html/index.html
    exit 1
fi

echo "✅ 文件验证通过"
echo ""

# 6. 设置权限
echo "🔐 设置文件权限..."
sudo chmod 644 /usr/share/nginx/html/index.html
echo "✅ 权限已设置"
echo ""

# 7. 强制重启 Nginx
echo "🔄 强制重启 Nginx..."
sudo systemctl stop nginx
sleep 2
sudo systemctl start nginx
sleep 3
echo "✅ Nginx 已重启"
echo ""

# 8. 验证服务
echo "🔍 验证服务..."
if sudo systemctl status nginx | grep -q "active (running)"; then
    echo "✅ Nginx 运行正常"
else
    echo "❌ Nginx 启动失败"
    exit 1
fi
echo ""

# 9. 本地验证
echo "🔍 本地访问验证..."
LOCAL_VERSION=$(curl -s http://localhost/index.html | grep -o "v2\.[0-9]\.[0-9]" | head -1)
echo "本地版本：$LOCAL_VERSION"

if [ "$LOCAL_VERSION" != "v2.1.3" ]; then
    echo "❌ 本地验证失败"
    exit 1
fi

LOCAL_FEATURES=$(curl -s http://localhost/index.html | grep -c "当日 XP\|累积 XP\|道具背包" || echo "0")
echo "本地特征匹配：$LOCAL_FEATURES 处"
echo "✅ 本地验证通过"
echo ""

# 10. 外网验证（可能需要等待 CDN 刷新）
echo "🌐 外网访问验证..."
echo "⚠️  注意：外网访问可能仍显示旧版本（CDN 缓存）"
echo "⏳ 等待 10 秒后测试..."
sleep 10

EXTERNAL_VERSION=$(curl -s http://114.215.210.41/index.html | grep -o "v2\.[0-9]\.[0-9]" | head -1 || echo "无法获取")
echo "外网版本：$EXTERNAL_VERSION"

if [ "$EXTERNAL_VERSION" = "v2.1.3" ]; then
    echo "✅ 外网验证通过（CDN 已刷新）"
else
    echo "⏳ 外网仍显示旧版本（CDN 缓存未刷新）"
    echo "💡 建议：等待 10-30 分钟 CDN 自然过期，或刷新浏览器缓存（Ctrl+F5）"
fi
echo ""

echo "========================================"
echo "✅ 小塔世界 v2.1.3 重新发布完成！"
echo "========================================"
echo ""
echo "📊 部署摘要："
echo "  - 服务器文件：v2.1.3 ✅"
echo "  - Nginx 状态：运行中 ✅"
echo "  - 本地访问：正常 ✅"
echo "  - 外网访问：等待 CDN 刷新 ⏳"
echo ""
echo "🌐 访问地址：http://114.215.210.41"
echo "⚠️  浏览器强制刷新：Ctrl + F5"
echo ""
