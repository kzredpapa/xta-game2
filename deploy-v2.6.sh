#!/bin/bash
# 小塔的努力记录 v2.6 部署脚本

echo "🚀 开始部署 v2.6..."

# 从 GitHub 下载
echo "📥 下载最新代码..."
curl -s https://raw.githubusercontent.com/kzredpapa/xta-game2/master/index.html -o /tmp/xta-game-v2.6.html

# 检查文件大小
if [ $(stat -c%s /tmp/xta-game-v2.6.html) -lt 1000 ]; then
    echo "❌ 下载失败，文件太小"
    exit 1
fi

# 复制到 Nginx 目录
echo "📁 复制文件..."
sudo cp /tmp/xta-game-v2.6.html /usr/share/nginx/html/index.html

# 重启 Nginx
echo "🔄 重启 Nginx..."
sudo systemctl restart nginx

# 检查状态
if sudo systemctl status nginx | grep -q "active"; then
    echo "✅ v2.6 部署完成！"
    echo "🌐 访问地址：http://114.215.210.41"
else
    echo "❌ Nginx 启动失败"
    exit 1
fi
