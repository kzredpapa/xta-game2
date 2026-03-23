# 🚀 Netlify Drop 部署指南

## 项目已准备就绪！

**文件夹位置**：`/home/admin/.openclaw/workspace/xta-game`

**核心文件**：`index.html`（已包含所有功能）

---

## 📱 部署步骤（5 分钟完成）

### 第 1 步：打开 Netlify Drop

**访问**：https://app.netlify.com/drop

### 第 2 步：登录/注册

**选项 A：GitHub 快速登录**（推荐）
1. 点击 "Sign up with GitHub" 或 "Log in with GitHub"
2. 授权 Netlify 访问你的 GitHub 账号
3. 登录成功

**选项 B：邮箱注册**
1. 输入邮箱地址
2. 设置密码
3. 验证邮箱

### 第 3 步：拖拽文件夹

1. **打开文件管理器**
2. **找到文件夹**：
   ```
   /home/admin/.openclaw/workspace/xta-game
   ```
3. **拖拽整个文件夹**到 Netlify Drop 页面
   - 看到 "Drop folder here" 提示
   - 松开鼠标

### 第 4 步：等待部署

- 上传进度条（约 10-30 秒）
- 部署状态：Building → Ready
- 成功后显示绿色 ✓

### 第 5 步：获得链接

部署成功后，你会看到：
```
https://xxxxx-xxxxx-xxxxx.netlify.app
```

**点击链接**预览网站！

---

## 🎯 部署后操作

### 1. 测试功能
- [ ] 打开链接
- [ ] 点击几个"完成"按钮
- [ ] 看 XP 是否正确增加
- [ ] 试试精力充能倒计时
- [ ] 刷新页面，数据应该还在

### 2. 自定义域名（可选）

**绑定 siatar.com：**
1. Netlify 控制台 → Site settings
2. Domain management → Add custom domain
3. 输入 `xta.siatar.com` 或 `siatar.com`
4. 按提示配置 DNS

**DNS 配置：**
```
类型：CNAME
名称：xta
值：xxxxx-xxxxx-xxxxx.netlify.app
```

### 3. 分享给小塔

**发送链接：**
```
🎮 小塔学习游戏上线啦！

链接：https://xxxxx-xxxxx-xxxxx.netlify.app

使用方法：
1. 打开链接
2. 完成任务点"完成"按钮
3. 攒 XP 换 SC 币
4. SC 币可以兑换奖励哦！

加油！🔥
```

---

## 💡 使用技巧

### 添加到手机桌面

**iPhone (Safari)：**
1. 打开链接
2. 点击底部"分享"按钮
3. 选择"添加到主屏幕"
4. 命名"小塔学习"

**Android (Chrome)：**
1. 打开链接
2. 点击右上角"⋮"菜单
3. 选择"添加到主屏幕"
4. 命名"小塔学习"

### 数据保存说明

- ✅ 数据自动保存在浏览器
- ✅ 关闭页面再打开，数据还在
- ❌ 清除浏览器数据会丢失进度
- ❌ 换设备数据不互通（第一版）

---

## 🔧 遇到问题？

### 问题 1：无法访问 Netlify
**解决**：
- 尝试用 Vercel：https://vercel.com/new
- 或用国内 CDN：阿里云 OSS

### 问题 2：部署失败
**检查**：
- 文件夹是否包含 `index.html`
- 网络连接是否正常
- 尝试重新上传

### 问题 3：页面空白
**解决**：
- 用 Chrome 或 Safari 浏览器
- 检查浏览器控制台（F12）
- 清除缓存后重试

### 问题 4：功能不正常
**检查**：
- 浏览器是否支持 localStorage
- 是否开启了隐私模式
- 换个浏览器试试

---

## 📊 部署信息

**项目名称**：xta-game  
**部署平台**：Netlify  
**部署方式**：Drop（静态托管）  
**费用**：免费  
**带宽**：100GB/月（免费额度）  
**构建时间**：约 30 秒  

---

## 🎉 部署成功后的下一步

1. **自己先测试一遍**
2. **给小塔演示如何使用**
3. **设定奖励规则**（如：1 SC = 30 分钟游戏时间）
4. **收集小塔反馈**
5. **根据反馈调整 XP 数值或功能**

---

## 📞 需要帮助？

遇到问题随时联系 Siatar！

**项目文件位置**：
```
/home/admin/.openclaw/workspace/xta-game/
├── index.html              # 游戏主文件
├── package.json            # 项目配置
├── vercel.json             # Vercel 配置（备用）
├── DEPLOY.md               # 通用部署指南
└── Netlify 部署指南.md      # 本文件
```

---

**现在就开始部署吧！** 🚀

打开 https://app.netlify.com/drop 拖拽文件夹即可！
