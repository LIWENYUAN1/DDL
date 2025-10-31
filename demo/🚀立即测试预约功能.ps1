# 预约功能测试脚本

Write-Host "🎉 预约功能完善完成 - 立即测试" -ForegroundColor Cyan
Write-Host ""
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Gray
Write-Host ""

Write-Host "📋 测试准备：" -ForegroundColor Yellow
Write-Host "   1️⃣  后端已编译完成" -ForegroundColor Green
Write-Host "   2️⃣  预约功能已全面升级" -ForegroundColor Green
Write-Host "   3️⃣  支持自动创建车辆记录" -ForegroundColor Green
Write-Host "   4️⃣  前后端完整集成" -ForegroundColor Green
Write-Host ""

Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Gray
Write-Host ""

Write-Host "🚀 启动步骤：" -ForegroundColor Cyan
Write-Host ""

Write-Host "【步骤1】启动后端（如果未启动）" -ForegroundColor Yellow
Write-Host "命令：cd F:\redame\demo; .\mvnw.cmd spring-boot:run" -ForegroundColor White
Write-Host ""

Write-Host "【步骤2】启动前端" -ForegroundColor Yellow
Write-Host "在新终端执行：cd F:\redame\vue-project; npm run dev" -ForegroundColor White
Write-Host ""

Write-Host "【步骤3】登录测试账号" -ForegroundColor Yellow
Write-Host "访问：http://localhost:5173" -ForegroundColor White
Write-Host "用户名：testuser456" -ForegroundColor White
Write-Host "密码：  123456" -ForegroundColor White
Write-Host ""

Write-Host "【步骤4】测试预约功能" -ForegroundColor Yellow
Write-Host "1. 点击商家卡片的'立即预约'按钮" -ForegroundColor White
Write-Host "2. 填写预约表单：" -ForegroundColor White
Write-Host "   - 选择服务项目" -ForegroundColor Gray
Write-Host "   - 选择预约时间" -ForegroundColor Gray
Write-Host "   - 输入车辆型号（如：雅马哈 R1）" -ForegroundColor Gray
Write-Host "   - 输入车牌号（如：云A12345）" -ForegroundColor Gray
Write-Host "   - 输入联系电话" -ForegroundColor Gray
Write-Host "   - 描述问题" -ForegroundColor Gray
Write-Host "3. 点击'确认预约'" -ForegroundColor White
Write-Host "4. 查看成功提示" -ForegroundColor White
Write-Host ""

Write-Host "【步骤5】查看预约记录" -ForegroundColor Yellow
Write-Host "点击左侧菜单'我的预约'，查看刚创建的预约" -ForegroundColor White
Write-Host ""

Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Gray
Write-Host ""

Write-Host "✨ 新功能亮点：" -ForegroundColor Magenta
Write-Host "   ✅ 自动创建车辆 - 无需预先注册车辆" -ForegroundColor Green
Write-Host "   ✅ 完整表单验证 - 车牌号、手机号格式检查" -ForegroundColor Green
Write-Host "   ✅ 优雅的UI设计 - 现代化对话框界面" -ForegroundColor Green
Write-Host "   ✅ 数据库持久化 - 预约信息完整保存" -ForegroundColor Green
Write-Host "   ✅ 预约管理功能 - 查看、取消预约" -ForegroundColor Green
Write-Host ""

Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Gray
Write-Host ""

Write-Host "📖 详细文档：" -ForegroundColor Cyan
Write-Host "查看 ✅预约功能完善完成.md 获取完整说明" -ForegroundColor White
Write-Host ""

Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Gray
Write-Host ""

$choice = Read-Host "是否现在启动前端进行测试？(Y/N)"
if ($choice -eq "Y" -or $choice -eq "y") {
    Write-Host ""
    Write-Host "🚀 正在启动前端..." -ForegroundColor Cyan
    cd F:\redame\vue-project
    npm run dev
} else {
    Write-Host ""
    Write-Host "💡 提示：准备好后，在新终端执行以下命令启动前端：" -ForegroundColor Yellow
    Write-Host "cd F:\redame\vue-project; npm run dev" -ForegroundColor White
    Write-Host ""
}





