# 🚀 小塔学习游戏 - 部署说明

## 项目已准备就绪！

**项目位置**：`/home/admin/.openclaw/workspace/xta-game`

**核心文件**：`index.html`（打开就能玩）

---

## 📱 方式 1：Netlify Drop（最简单）

### 步骤：

1. **打开浏览器**，访问：https://app.netlify.com/drop

2. **登录**（可选）：
   - 点击 "Sign up" 或 "Log in"
   - 推荐用 GitHub 账号快速登录

3. **拖拽文件夹**：
   - 打开文件管理器
   - 找到文件夹：`/home/admin/.openclaw/workspace/xta-game`
   - 把整个文件夹拖到 Netlify Drop 页面

4. **等待部署**（约 30 秒）：
   - 上传进度条走完
   - 部署成功后显示绿色 ✓

5. **获得链接**：
   - 格式：`https://xxx-xxx-xxx.netlify.app`
   - 点击 "Open production deploy" 预览

6. **复制链接**分享给小塔！

---

## 📱 方式 2：Vercel + GitHub

### 步骤：

1. **GitHub 创建仓库**：
   - 访问 https://github.com/new
   - 仓库名：`xta-game`
   - 设为 Public
   - 点击 "Create repository"

2. **推送代码**：
   ```bash
   cd /home/admin/.openclaw/workspace/xta-game
   git remote add origin https://github.com/你的用户名/xta-game.git
   git push -u origin master
   ```

3. **Vercel 部署**：
   - 访问 https://vercel.com/new
   - 选择 "Import Git Repository"
   - 选择 `xta-game` 仓库
   - 点击 "Deploy"

4. **获得链接**：
   - 格式：`https://xta-game.vercel.app`

---

## 🎮 功能说明

### XP 奖励表
| 任务类型 | XP 奖励 |
|---------|--------|
| 语文/数学/英语作业 | +20 XP |
| 提前预习/今日复习/篮球 | +15 XP |
| 整理书桌/喝水 | +10 XP |
| 吃饭打卡（早/中/晚） | +10 XP/餐 |
| 精力充能（25 分钟） | +10 XP |

### 兑换规则
- **100 XP = 1 SC**
- 每日最多兑换 1 次
- SC 币可累计，用于兑换奖励

### 每日目标示例
```
作业 3 科：20×3 = 60 XP
额外挑战 1 个：15 XP
生活任务 2 个：20 XP
吃饭 3 餐：30 XP
精力充能 1 次：10 XP
────────────────────
总计：135 XP → 兑换 1 SC（剩 35 XP）
```

---

## 💡 使用提示

1. **添加到手机桌面**：
   - Safari：分享 → 添加到主屏幕
   - Chrome：菜单 → 添加到主屏幕

2. **数据保存**：
   - 所有数据存储在浏览器 localStorage
   - 清除浏览器数据会丢失进度
   - 建议不要清除浏览器缓存

3. **多设备使用**：
   - 第一版数据不互通
   - 每台设备独立记录进度

---

## 🎯 部署后

1. **测试功能**：
   - 完成几个任务
   - 点击"完成"按钮
   - 看 XP 是否正确增加
   - 试试精力充能倒计时

2. **分享给小塔**：
   - 发送链接
   - 教小塔如何使用
   - 设置奖励规则（如：1 SC = 30 分钟游戏时间）

3. **后续优化**：
   - 收集小塔反馈
   - 调整 XP 奖励数值
   - 添加更多成就

---

## ❓ 遇到问题？

- **无法访问 Netlify**：尝试用 Vercel 方案
- **部署失败**：检查文件夹是否包含 `index.html`
- **页面空白**：用 Chrome/Safari 浏览器打开

---

**祝部署顺利！小塔玩得开心！** 🎉
