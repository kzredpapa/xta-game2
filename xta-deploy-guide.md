# 小塔世界自动化部署指南

**创建时间：** 2026-03-26  
**架构：** OpenClaw 控制端 + 服务器执行端

---

## 🏗️ 架构设计

```
┌─────────────────┐         ┌─────────────────┐
│   OpenClaw      │  SSH    │   阿里云服务器   │
│   (控制端)      │ ──────> │   (执行端)      │
│                 │         │                 │
│ 发送简单指令     │         │ 预置维护脚本     │
│ xta-deploy.sh   │         │ /opt/scripts/   │
└─────────────────┘         └─────────────────┘
```

---

## 📁 文件结构

| 文件 | 位置 | 用途 |
|------|------|------|
| **部署脚本** | `/opt/scripts/xta-deploy.sh` | 服务器端维护脚本 |
| **Systemd 服务** | `/etc/systemd/system/nginx.service` | Nginx 守护进程 |
| **日志文件** | `/var/log/xta-deploy.log` | 部署日志 |
| **备份目录** | `/var/backups/xta-game/` | 旧版本备份 |

---

## 🚀 服务器端配置

### 步骤 1：创建脚本目录

```bash
sudo mkdir -p /opt/scripts
sudo mkdir -p /var/backups/xta-game
sudo touch /var/log/xta-deploy.log
sudo chmod 666 /var/log/xta-deploy.log
```

### 步骤 2：上传部署脚本

```bash
# 从 GitHub 下载
sudo curl -sL "https://raw.githubusercontent.com/kzredpapa/xta-game2/master/scripts/xta-deploy.sh" \
  -o /opt/scripts/xta-deploy.sh

# 设置执行权限
sudo chmod +x /opt/scripts/xta-deploy.sh
```

### 步骤 3：验证脚本

```bash
# 查看帮助
sudo /opt/scripts/xta-deploy.sh

# 查看状态
sudo /opt/scripts/xta-deploy.sh status

# 查看日志
sudo /opt/scripts/xta-deploy.sh logs 20
```

---

## 🎮 OpenClaw 端使用

### 基本命令

```python
# 部署最新版本
ssh admin@114.215.210.41 "sudo /opt/scripts/xta-deploy.sh deploy"

# 查看状态
ssh admin@114.215.210.41 "sudo /opt/scripts/xta-deploy.sh status"

# 查看日志
ssh admin@114.215.210.41 "sudo /opt/scripts/xta-deploy.sh logs 50"

# 清理旧备份
ssh admin@114.215.210.41 "sudo /opt/scripts/xta-deploy.sh cleanup"
```

### 简化命令（推荐）

在服务器创建快捷命令：

```bash
# 添加到 ~/.bashrc
echo 'alias xta-deploy="sudo /opt/scripts/xta-deploy.sh"' >> ~/.bashrc
source ~/.bashrc

# 之后可以简写
xta-deploy deploy
xta-deploy status
xta-deploy logs
```

---

## 📊 脚本功能

### deploy - 部署最新版本

```bash
sudo /opt/scripts/xta-deploy.sh deploy
```

**执行流程：**
1. 备份旧文件到 `/var/backups/xta-game/`
2. 从 GitHub 下载最新代码
3. 验证文件完整性（大小、版本）
4. 重启 Nginx
5. 本地验证版本
6. 记录日志

**输出示例：**
```
[2026-03-26 18:00:00] === 开始部署小塔世界 ===
[2026-03-26 18:00:01] ✅ 备份至：/var/backups/xta-game/index.html.bak.20260326180001
[2026-03-26 18:00:02] 📥 从 GitHub 下载...
[2026-03-26 18:00:03] ✅ 下载完成 (51539 bytes)
[2026-03-26 18:00:03] 📋 检测到版本：v2.1.3
[2026-03-26 18:00:04] 🔄 重启 Nginx...
[2026-03-26 18:00:06] ✅ Nginx 运行正常
[2026-03-26 18:00:06] 📍 本地版本：v2.1.3
[2026-03-26 18:00:06] ✅ 部署完成！版本：v2.1.3
```

### status - 查看当前状态

```bash
sudo /opt/scripts/xta-deploy.sh status
```

**输出示例：**
```
=== 小塔世界状态 ===
Nginx 状态：
● nginx.service - The nginx HTTP and reverse proxy server
   Active: active (running) since Thu 2026-03-26

当前版本：
v2.1.3

文件大小：
-rw-r--r-- 1 root root 51K ...

最近备份：
-rw-r--r-- 1 root root 51K Mar 26 18:00 index.html.bak.20260326180001
```

### logs - 查看部署日志

```bash
# 查看最近 50 行
sudo /opt/scripts/xta-deploy.sh logs 50

# 查看最近 100 行
sudo /opt/scripts/xta-deploy.sh logs 100
```

### cleanup - 清理旧备份

```bash
sudo /opt/scripts/xta-deploy.sh cleanup
```

**说明：** 保留最近 5 个备份，删除更早的备份。

---

## 🔒 安全加固

### SSH 密钥认证（推荐）

```bash
# 在 OpenClaw 服务器生成密钥
ssh-keygen -t ed25519 -f ~/.ssh/xta-deploy -N ""

# 复制公钥到阿里云服务器
ssh-copy-id -i ~/.ssh/xta-deploy.pub admin@114.215.210.41

# 测试连接
ssh -i ~/.ssh/xta-deploy admin@114.215.210.41 "uptime"
```

### 限制命令权限

编辑 `/etc/sudoers`：

```bash
# 允许 admin 用户无需密码执行部署脚本
admin ALL=(ALL) NOPASSWD: /opt/scripts/xta-deploy.sh
```

---

## 📋 运维流程

### 日常部署

```bash
# 1. 查看当前状态
xta-deploy status

# 2. 部署新版本
xta-deploy deploy

# 3. 验证部署
xta-deploy logs 20

# 4. 外网验证（等待 CDN 刷新）
curl -s http://114.215.210.41/index.html | grep -o "v2\.[0-9]\.[0-9]"
```

### 回滚操作

```bash
# 1. 查看备份列表
ls -lt /var/backups/xta-game/*.bak.*

# 2. 恢复指定备份
sudo cp /var/backups/xta-game/index.html.bak.YYYYMMDDHHMMSS \
  /usr/share/nginx/html/index.html

# 3. 重启 Nginx
sudo systemctl restart nginx

# 4. 验证
curl -s http://127.0.0.1/index.html | grep -o "v2\.[0-9]\.[0-9]"
```

---

## 🎯 最佳实践

### 1. 部署前检查

```bash
# 检查 GitHub 代码
curl -sL "https://raw.githubusercontent.com/kzredpapa/xta-game2/master/index.html" | \
  grep -o "v2\.[0-9]\.[0-9]"

# 检查服务器状态
xta-deploy status
```

### 2. 部署后验证

```bash
# 本地验证
xta-deploy status

# 外网验证
curl -s http://114.215.210.41/index.html | grep -o "v2\.[0-9]\.[0-9]"

# 功能测试
# 访问 http://114.215.210.41 检查新功能
```

### 3. 定期清理

```bash
# 每周清理一次旧备份
xta-deploy cleanup
```

---

## 📊 故障排查

### 问题 1：部署失败

```bash
# 查看日志
xta-deploy logs 100

# 检查 Nginx 状态
sudo systemctl status nginx

# 手动恢复备份
sudo cp /var/backups/xta-game/index.html.bak.* /usr/share/nginx/html/index.html
sudo systemctl restart nginx
```

### 问题 2：CDN 缓存未刷新

```bash
# 检查本地版本
curl -s http://127.0.0.1/index.html | grep -o "v2\.[0-9]\.[0-9]"

# 检查外网版本
curl -s http://114.215.210.41/index.html | grep -o "v2\.[0-9]\.[0-9]"

# 如果不同，等待 CDN 刷新或提交阿里云工单
```

### 问题 3：脚本权限错误

```bash
# 检查权限
ls -l /opt/scripts/xta-deploy.sh

# 修复权限
sudo chmod +x /opt/scripts/xta-deploy.sh
```

---

## 📝 维护记录

| 日期 | 操作 | 版本 | 操作者 | 结果 |
|------|------|------|--------|------|
| 2026-03-26 | 初始部署 | v2.1.3 | Siatar | ✅ 成功 |
| 2026-03-26 | 创建维护脚本 | - | Siatar | ✅ 成功 |

---

*最后更新：2026-03-26 18:00*  
*维护者：Siatar*
