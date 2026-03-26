#!/bin/bash
# 小塔世界 v2.1.3 可视化重新部署
# 显示完整的下载和覆盖过程

set -e

echo "========================================"
echo "🚀 小塔世界 v2.1.3 可视化重新部署"
echo "========================================"
echo ""
echo "📋 部署流程预览："
echo "  1. 停止 Nginx"
echo "  2. 备份旧文件"
echo "  3. 删除旧文件"
echo "  4. 从 GitHub 下载新文件（显示进度）"
echo "  5. 验证文件完整性"
echo "  6. 启动 Nginx"
echo "  7. 验证服务"
echo ""
read -p "按回车键开始部署..."
echo ""

# 1. 停止 Nginx
echo "🛑 步骤 1/7: 停止 Nginx..."
sudo systemctl stop nginx
echo "✅ Nginx 已停止"
echo ""

# 2. 备份旧文件
echo "📦 步骤 2/7: 备份旧文件..."
BACKUP_FILE="/usr/share/nginx/html/index.html.bak.$(date +%Y%m%d%H%M%S)"
if [ -f /usr/share/nginx/html/index.html ]; then
    sudo cp /usr/share/nginx/html/index.html $BACKUP_FILE
    echo "✅ 备份至：$BACKUP_FILE"
else
    echo "⚠️  无文件可备份"
fi
echo ""

# 3. 删除旧文件
echo "🗑️  步骤 3/7: 删除旧文件..."
sudo rm -f /usr/share/nginx/html/index.html
if [ ! -f /usr/share/nginx/html/index.html ]; then
    echo "✅ 文件已删除"
else
    echo "❌ 删除失败"
    exit 1
fi
echo ""

# 4. 从 GitHub 下载（显示进度）
echo "📥 步骤 4/7: 从 GitHub 下载新文件..."
echo "🔗 下载 URL: https://raw.githubusercontent.com/kzredpapa/xta-game2/master/index.html"
echo ""

# 使用 curl 显示进度
sudo curl -sL --progress-bar "https://raw.githubusercontent.com/kzredpapa/xta-game2/master/index.html?redeploy=$(date +%s)" -o /usr/share/nginx/html/index.html

echo ""
echo "✅ 下载完成"
echo ""

# 显示下载统计
echo "📊 下载统计："
FILE_SIZE=$(stat -c%s /usr/share/nginx/html/index.html 2>/dev/null || stat -f%z /usr/share/nginx/html/index.html 2>/dev/null)
echo "  文件大小：$FILE_SIZE bytes ($(echo "scale=2; $FILE_SIZE/1024" | bc) KB)"
echo "  文件路径：/usr/share/nginx/html/index.html"
echo ""

# 5. 验证文件
echo "🔍 步骤 5/7: 验证文件完整性..."
echo ""

# 检查文件大小
if [ "$FILE_SIZE" -lt 1000 ]; then
    echo "❌ 文件太小（$FILE_SIZE bytes），下载可能失败"
    echo "🔄 恢复备份..."
    sudo cp $BACKUP_FILE /usr/share/nginx/html/index.html
    exit 1
fi
echo "✅ 文件大小正常"

# 检查版本号
VERSION=$(grep -o "v2\.[0-9]\.[0-9]" /usr/share/nginx/html/index.html | head -1)
echo "  检测到版本：$VERSION"
if [ "$VERSION" != "v2.1.3" ]; then
    echo "❌ 版本不正确，期望 v2.1.3，实际：$VERSION"
    echo "🔄 恢复备份..."
    sudo cp $BACKUP_FILE /usr/share/nginx/html/index.html
    exit 1
fi
echo "✅ 版本正确"

# 检查 v2.1.3 特征
FEATURES=$(grep -c "当日 XP\|累积 XP\|道具背包\|时间暂停器" /usr/share/nginx/html/index.html || echo "0")
echo "  v2.1.3 特征匹配：$FEATURES 处"
if [ "$FEATURES" -lt 10 ]; then
    echo "❌ 特征匹配不足，可能下载了旧版本"
    echo "🔄 恢复备份..."
    sudo cp $BACKUP_FILE /usr/share/nginx/html/index.html
    exit 1
fi
echo "✅ 特征匹配正常"

# 显示文件前 10 行
echo ""
echo "📄 文件预览（前 10 行）："
sudo head -10 /usr/share/nginx/html/index.html | cat -n
echo ""

echo "✅ 文件验证通过"
echo ""

# 6. 启动 Nginx
echo "🔄 步骤 6/7: 启动 Nginx..."
sudo systemctl start nginx
sleep 3

if sudo systemctl status nginx | grep -q "active (running)"; then
    echo "✅ Nginx 已启动并运行"
else
    echo "❌ Nginx 启动失败"
    exit 1
fi
echo ""

# 7. 验证服务
echo "🔍 步骤 7/7: 验证服务..."
echo ""

# 本地访问测试
echo "📍 本地访问测试："
LOCAL_VERSION=$(curl -s http://localhost/index.html | grep -o "v2\.[0-9]\.[0-9]" | head -1)
echo "  本地版本：$LOCAL_VERSION"
if [ "$LOCAL_VERSION" != "v2.1.3" ]; then
    echo "❌ 本地验证失败"
    exit 1
fi
echo "✅ 本地访问正常"
echo ""

# 显示当前运行进程
echo "📊 当前 Nginx 进程："
ps aux | grep nginx | grep -v grep
echo ""

# 外网访问测试
echo "🌐 外网访问测试："
echo "⏳ 等待 5 秒..."
sleep 5
EXTERNAL_VERSION=$(curl -s --connect-timeout 5 http://114.215.210.41/index.html | grep -o "v2\.[0-9]\.[0-9]" | head -1 || echo "无法获取")
echo "  外网版本：$EXTERNAL_VERSION"
if [ "$EXTERNAL_VERSION" = "v2.1.3" ]; then
    echo "✅ 外网验证通过（CDN 已刷新）"
else
    echo "⏳ 外网仍显示旧版本（CDN 缓存未刷新）"
    echo "💡 建议：等待 10-30 分钟或刷新浏览器缓存"
fi
echo ""

echo "========================================"
echo "✅ 小塔世界 v2.1.3 重新部署完成！"
echo "========================================"
echo ""
echo "📊 部署摘要："
echo "  ✅ 服务器文件：v2.1.3"
echo "  ✅ Nginx 状态：运行中"
echo "  ✅ 本地访问：正常"
echo "  ⏳ 外网访问：等待 CDN 刷新"
echo ""
echo "🌐 访问地址：http://114.215.210.41"
echo "⚠️  浏览器强制刷新：Ctrl + F5"
echo ""
echo "📋 备份文件位置：$BACKUP_FILE"
echo ""
