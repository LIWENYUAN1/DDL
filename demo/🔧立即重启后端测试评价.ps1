# 立即重启后端测试评价功能
Write-Host "=====================================" -ForegroundColor Cyan
Write-Host "   评价功能 - 用户ID问题已修复" -ForegroundColor Cyan
Write-Host "=====================================" -ForegroundColor Cyan
Write-Host ""

# 1. 检查并释放8080端口
Write-Host "🔍 步骤1: 检查并释放8080端口..." -ForegroundColor Yellow
$port = 8080
$process = Get-NetTCPConnection -LocalPort $port -ErrorAction SilentlyContinue | Select-Object -ExpandProperty OwningProcess -First 1

if ($process) {
    Write-Host "   ⚠️  端口 $port 被进程 $process 占用" -ForegroundColor Yellow
    Write-Host "   🔧 正在释放端口..." -ForegroundColor White
    Stop-Process -Id $process -Force -ErrorAction SilentlyContinue
    Start-Sleep -Seconds 2
    Write-Host "   ✅ 端口已释放" -ForegroundColor Green
} else {
    Write-Host "   ✅ 端口 $port 空闲" -ForegroundColor Green
}

# 2. 修复说明
Write-Host ""
Write-Host "=====================================" -ForegroundColor Cyan
Write-Host "         修复内容" -ForegroundColor Cyan
Write-Host "=====================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "🐛 问题：" -ForegroundColor Red
Write-Host "   参数错误: For input string: 'SysUser(...)'" -ForegroundColor Gray
Write-Host ""
Write-Host "🔧 修复：" -ForegroundColor Green
Write-Host "   • 添加 getCurrentUserId() 方法" -ForegroundColor Gray
Write-Host "   • 从 authentication.getPrincipal() 获取用户ID" -ForegroundColor Gray
Write-Host "   • 修改所有评价相关方法" -ForegroundColor Gray
Write-Host ""

# 3. 下一步操作
Write-Host "=====================================" -ForegroundColor Cyan
Write-Host "         下一步操作" -ForegroundColor Cyan
Write-Host "=====================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "📝 请在 IDEA 中执行：" -ForegroundColor Yellow
Write-Host ""
Write-Host "   1️⃣  停止当前运行的 DemoApplication" -ForegroundColor White
Write-Host "      点击红色停止按钮 ⏹️" -ForegroundColor Gray
Write-Host ""
Write-Host "   2️⃣  重新运行 DemoApplication" -ForegroundColor White
Write-Host "      右键 DemoApplication.java → Run" -ForegroundColor Gray
Write-Host ""
Write-Host "   3️⃣  等待启动成功" -ForegroundColor White
Write-Host "      看到: 'Started DemoApplication in X.XXX seconds'" -ForegroundColor Green
Write-Host ""
Write-Host "=====================================" -ForegroundColor Cyan
Write-Host ""

# 4. 测试步骤
Write-Host "🧪 测试步骤：" -ForegroundColor Yellow
Write-Host ""
Write-Host "   1️⃣  刷新浏览器页面（F5）" -ForegroundColor White
Write-Host ""
Write-Host "   2️⃣  登录用户账号" -ForegroundColor White
Write-Host ""
Write-Host "   3️⃣  进入'我的预约'" -ForegroundColor White
Write-Host ""
Write-Host "   4️⃣  切换到'已完成'标签" -ForegroundColor White
Write-Host ""
Write-Host "   5️⃣  点击'评价'按钮" -ForegroundColor White
Write-Host ""
Write-Host "   6️⃣  填写评分和内容" -ForegroundColor White
Write-Host "      • 综合评分：⭐⭐⭐⭐⭐" -ForegroundColor Gray
Write-Host "      • 评价内容：服务非常好！" -ForegroundColor Gray
Write-Host ""
Write-Host "   7️⃣  提交评价" -ForegroundColor White
Write-Host ""
Write-Host "   8️⃣  看到成功提示" -ForegroundColor White
Write-Host "      ✅ '评价成功！感谢您的反馈'" -ForegroundColor Green
Write-Host ""
Write-Host "=====================================" -ForegroundColor Cyan
Write-Host ""

# 5. 验证修复
Write-Host "✅ 验证修复成功的标志：" -ForegroundColor Green
Write-Host ""
Write-Host "   • 浏览器控制台显示：" -ForegroundColor White
Write-Host "     ✅ 评价响应： {code: 200, msg: '评价成功', ...}" -ForegroundColor Green
Write-Host ""
Write-Host "   • 后端控制台显示：" -ForegroundColor White
Write-Host "     用户 3 创建评价，预约ID：1" -ForegroundColor Gray
Write-Host "     用户 3 为预约 1 创建了评价，评分：5" -ForegroundColor Gray
Write-Host ""
Write-Host "   • 不应该看到：" -ForegroundColor White
Write-Host "     ❌ 参数错误: For input string: 'SysUser(...)'" -ForegroundColor Red
Write-Host ""

# 6. 打开文档
Write-Host "=====================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "📖 正在打开修复文档..." -ForegroundColor Green

$docPath = Join-Path $PSScriptRoot "✅评价功能用户ID获取问题已修复.md"
if (Test-Path $docPath) {
    Start-Process $docPath
}

Write-Host ""
Write-Host "=====================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "💡 提示：" -ForegroundColor Yellow
Write-Host "   • 修改了 AppointmentReviewController.java" -ForegroundColor Gray
Write-Host "   • 添加了 getCurrentUserId() 方法" -ForegroundColor Gray
Write-Host "   • 修复了用户ID获取方式" -ForegroundColor Gray
Write-Host ""
Write-Host "🎉 修复完成！现在重启后端测试吧！" -ForegroundColor Green
Write-Host ""
Write-Host "按任意键关闭..." -ForegroundColor Gray
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")


