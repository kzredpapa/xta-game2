# 🚀 一键部署方案

## 由于权限限制，我帮你准备了两个自动部署方案：

---

## 方案 A：GitHub + Vercel（推荐）

### 第 1 步：创建 GitHub 仓库

1. 访问：https://github.com/new
2. 仓库名：`xta-game`
3. 设为 **Public**
4. 点击 **"Create repository"**

### 第 2 步：推送代码

复制以下命令，在终端执行：

```bash
cd /home/admin/.openclaw/workspace/xta-game
git remote add origin https://github.com/你的 GitHub 用户名/xta-game.git
git push -u origin master
```

### 第 3 步：Vercel 自动部署

1. 访问：https://vercel.com/new
2. 用 GitHub 账号登录
3. 选择 "Import Git Repository"
4. 找到 `xta-game` 仓库
5. 点击 "Deploy"

**完成！** 约 1 分钟后获得链接：`https://xta-game.vercel.app`

---

## 方案 B：Netlify 网页上传（无需命令行）

### 步骤：

1. 访问：https://app.netlify.com/drop
2. 登录（可用 GitHub）
3. 点击 **"choose a different folder"** 或 **"浏览"**
4. 选择文件夹：`/home/admin/.openclaw/workspace/xta-game`
5. 等待上传完成

**完成！** 获得链接：`https://xxx.netlify.app`

---

## 我推荐方案 A（GitHub + Vercel）

**优点：**
- ✅ 自动部署（每次 push 自动更新）
- ✅ 免费 HTTPS
- ✅ 速度快
- ✅ 可绑定自定义域名

**缺点：**
- 需要 GitHub 账号（免费）

---

## 快速操作指南

### 如果你有 GitHub 账号：

```bash
# 1. 复制你的 GitHub 用户名
# 2. 替换下面的 YOUR_USERNAME 为你的用户名
# 3. 执行以下命令：

cd /home/admin/.openclaw/workspace/xta-game
git remote add origin https://github.com/YOUR_USERNAME/xta-game.git
git push -u origin master
```

然后去 https://vercel.com/new 部署即可！

### 如果你没有 GitHub 账号：

1. 先注册：https://github.com/signup
2. 然后用上面的命令推送
3. 再去 Vercel 部署

---

## 需要我帮你执行命令吗？

告诉我你的 GitHub 用户名，我可以帮你执行推送命令！
