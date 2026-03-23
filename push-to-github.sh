#!/bin/bash
# 小塔游戏 - GitHub 推送脚本

echo "🚀 开始推送代码到 GitHub..."
echo ""
echo "仓库：https://github.com/kzpapared/xta-game"
echo ""
echo "💡 提示：输入密码时不会显示字符，这是正常的"
echo ""

cd /home/admin/.openclaw/workspace/xta-game

echo "执行推送命令..."
git push -u origin master

echo ""
if [ $? -eq 0 ]; then
    echo "✅ 推送成功！"
    echo ""
    echo "下一步："
    echo "1. 访问：https://vercel.com/new"
    echo "2. 用 GitHub 账号登录"
    echo "3. 选择 'Import Git Repository'"
    echo "4. 找到 'xta-game' 仓库"
    echo "5. 点击 'Deploy'"
    echo ""
    echo "约 1 分钟后获得链接：https://xta-game.vercel.app"
else
    echo "❌ 推送失败，请检查："
    echo "1. GitHub 用户名和密码是否正确"
    echo "2. 网络连接是否正常"
    echo "3. GitHub 账号是否已验证邮箱"
fi
