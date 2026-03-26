# 🔧 小塔世界 v2.1.3 - 服务器部署命令

## 在服务器终端执行以下命令：

```bash
# === 第 1 步：确认当前版本 ===
echo "当前版本检查："
grep -o "v2\.[0-9]\.[0-9]" /usr/share/nginx/html/index.html | head -1

# === 第 2 步：备份 ===
echo "备份旧版本..."
sudo cp /usr/share/nginx/html/index.html /usr/share/nginx/html/index.html.bak.$(date +%Y%m%d%H%M)

# === 第 3 步：下载新版本 ===
echo "下载 v2.1.3..."
curl -sL https://raw.githubusercontent.com/kzredpapa/xta-game2/master/index.html -o /tmp/xta-new.html

# === 第 4 步：验证下载 ===
echo "验证下载..."
if grep -q "道具背包" /tmp/xta-new.html; then
    echo "✅ 下载成功，包含 v2.1.3 特性"
else
    echo "❌ 下载失败，文件不包含 v2.1.3 特性"
    exit 1
fi

# === 第 5 步：覆盖安装 ===
echo "覆盖安装..."
sudo cp /tmp/xta-new.html /usr/share/nginx/html/index.html

# === 第 6 步：重启 Nginx ===
echo "重启 Nginx..."
sudo systemctl restart nginx

# === 第 7 步：验证 ===
echo "验证部署..."
sleep 2
curl -s http://114.215.210.41/index.html | grep -o "v2\.[0-9]\.[0-9]" | head -1

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "✅ v2.1.3 部署完成！"
echo "🌐 访问：http://114.215.210.41"
echo "⚠️  浏览器强制刷新：Ctrl+F5 或 Cmd+Shift+R"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
```

---

## 如果还是不行，检查：

### 1. Nginx 配置文件
```bash
sudo cat /etc/nginx/nginx.conf | grep -A5 "root"
```

### 2. 确认文件路径
```bash
ls -la /usr/share/nginx/html/
```

### 3. 检查 Nginx 状态
```bash
sudo systemctl status nginx
```

### 4. 查看 Nginx 错误日志
```bash
sudo tail -20 /var/log/nginx/error.log
```

---

## 备选方案：直接编辑服务器文件

如果上面都不行，直接在服务器创建文件：

```bash
# 在服务器上直接创建
cat > /usr/share/nginx/html/index.html << 'EOF'
(复制本地 index.html 内容)
EOF
```
