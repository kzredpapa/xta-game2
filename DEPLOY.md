# 小塔学习游戏 - 部署指南

## 项目已就绪！

项目位置：`/home/admin/.openclaw/workspace/xta-game`

核心文件：
- `index.html` - 完整的静态网页（包含所有 CSS 和 JavaScript）
- `package.json` - Vercel 配置
- `vercel.json` - 部署配置

---

## 部署到 Vercel（推荐）

### 方法 1：通过 Vercel 网页（最简单）

1. 访问 https://vercel.com
2. 登录（可用 GitHub 账号）
3. 点击 "Add New Project"
4. 选择 "Import Git Repository"
5. 选择你的 GitHub 账号
6. 上传项目代码到 GitHub（或拖拽到 Vercel）
7. Vercel 会自动部署

### 方法 2：通过 Vercel CLI

```bash
# 安装 Vercel CLI
npm install -g vercel

# 登录
vercel login

# 部署
cd /home/admin/.openclaw/workspace/xta-game
vercel --prod
```

---

## 部署后配置

### 自定义域名（可选）

1. 在 Vercel 项目设置 → Domains
2. 添加 `xta.siatar.com` 或 `siatar.com`
3. 按提示配置 DNS

### 备案

- Vercel 是海外服务，**无需备案**即可访问
- 如需国内访问更快，备案后迁移到阿里云

---

## 功能说明

### XP 奖励
| 任务 | XP |
|------|-----|
| 语文/数学/英语作业 | +20 |
| 预习/复习/篮球 | +15 |
| 整理书桌/喝水 | +10 |
| 精力充能（25min） | +10 |
| 吃饭打卡 | +10/餐 |

### 兑换规则
- 100 XP = 1 SC
- 每日最多兑换 1 次

### 数据存储
- 所有数据存储在浏览器 localStorage
- 无需账号，打开即用
- 清除浏览器数据会丢失进度

---

## 后续优化

1. **添加账号系统** - 多设备同步
2. **爸爸审核端** - 作业确认功能
3. **钉钉同步** - 自动获取作业
4. **成就系统** - 更多徽章
5. **统计图表** - 学习趋势分析

---

## 技术支持

有问题随时联系 Siatar！🚀
