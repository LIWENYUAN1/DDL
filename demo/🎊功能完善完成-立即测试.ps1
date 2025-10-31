# 🎊 摩托车服务平台功能完善 - 立即测试

Write-Host ""
Write-Host "═══════════════════════════════════════════════════" -ForegroundColor Cyan
Write-Host "    🎉  摩托车服务平台 - 功能完善完成！" -ForegroundColor Green
Write-Host "═══════════════════════════════════════════════════" -ForegroundColor Cyan
Write-Host ""

Write-Host "📋 已完成的功能：" -ForegroundColor Yellow
Write-Host ""
Write-Host "   ✅ 后端API完整实现" -ForegroundColor Green
Write-Host "      • 用户预约管理（创建、查看、取消）" -ForegroundColor White
Write-Host "      • 商家预约管理（查看、确认、完成、拒绝）" -ForegroundColor White
Write-Host "      • 管理员后台管理（用户、商家、预约、统计）" -ForegroundColor White
Write-Host "      • 公共API（查询商家、获取商家详情）" -ForegroundColor White
Write-Host ""
Write-Host "   ✅ 权限配置完善" -ForegroundColor Green
Write-Host "      • 用户端API权限" -ForegroundColor White
Write-Host "      • 商家端API权限" -ForegroundColor White
Write-Host "      • 管理员端API权限" -ForegroundColor White
Write-Host "      • 公共API（无需登录）" -ForegroundColor White
Write-Host ""
Write-Host "   ✅ 前端API调用文件" -ForegroundColor Green
Write-Host "      • vue-project/src/api/appointment.ts" -ForegroundColor White
Write-Host "      • vue-project/src/api/merchant.ts" -ForegroundColor White
Write-Host "      • vue-project/src/api/admin.ts" -ForegroundColor White
Write-Host ""

Write-Host "─────────────────────────────────────────────────" -ForegroundColor Gray
Write-Host ""
Write-Host "🔍 检查服务状态..." -ForegroundColor Cyan
Write-Host ""

# 检查后端服务
$backendRunning = $false
try {
    $response = Invoke-WebRequest -Uri "http://localhost:8080/actuator/health" -TimeoutSec 2 -UseBasicParsing -ErrorAction SilentlyContinue
    if ($response.StatusCode -eq 200) {
        $backendRunning = $true
    }
} catch {
    $backendRunning = $false
}

# 检查前端服务
$frontendRunning = $false
try {
    $response = Invoke-WebRequest -Uri "http://localhost:5173" -TimeoutSec 2 -UseBasicParsing -ErrorAction SilentlyContinue
    if ($response.StatusCode -eq 200) {
        $frontendRunning = $true
    }
} catch {
    $frontendRunning = $false
}

if ($backendRunning) {
    Write-Host "✅ 后端服务正在运行（http://localhost:8080）" -ForegroundColor Green
} else {
    Write-Host "❌ 后端服务未运行" -ForegroundColor Red
}

if ($frontendRunning) {
    Write-Host "✅ 前端服务正在运行（http://localhost:5173）" -ForegroundColor Green
} else {
    Write-Host "❌ 前端服务未运行" -ForegroundColor Red
}

Write-Host ""
Write-Host "─────────────────────────────────────────────────" -ForegroundColor Gray
Write-Host ""

if (-not $backendRunning -or -not $frontendRunning) {
    Write-Host "🔧 需要启动服务" -ForegroundColor Yellow
    Write-Host ""
    
    if (-not $backendRunning) {
        Write-Host "启动后端服务：" -ForegroundColor Yellow
        Write-Host "  cd F:\redame\demo" -ForegroundColor White
        Write-Host "  .\mvnw.cmd spring-boot:run" -ForegroundColor Cyan
        Write-Host ""
    }
    
    if (-not $frontendRunning) {
        Write-Host "启动前端服务：" -ForegroundColor Yellow
        Write-Host "  cd F:\redame\vue-project" -ForegroundColor White
        Write-Host "  npm run dev" -ForegroundColor Cyan
        Write-Host ""
    }
    
    Write-Host "两个服务都启动后，再次运行此脚本进行测试" -ForegroundColor Yellow
    Write-Host ""
} else {
    Write-Host "🎯 测试账号信息：" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "  👤 普通用户：" -ForegroundColor Yellow
    Write-Host "     用户名：testuser456" -ForegroundColor White
    Write-Host "     密码：Test123456" -ForegroundColor White
    Write-Host "     功能：创建预约、查看预约、取消预约" -ForegroundColor Gray
    Write-Host ""
    Write-Host "  👨‍💼 管理员：" -ForegroundColor Yellow
    Write-Host "     用户名：admin123" -ForegroundColor White
    Write-Host "     密码：Admin123456" -ForegroundColor White
    Write-Host "     功能：用户管理、商家审核、查看所有预约" -ForegroundColor Gray
    Write-Host ""
    Write-Host "  🏪 商家：" -ForegroundColor Yellow
    Write-Host "     需要先注册（在商家登录页面注册）" -ForegroundColor White
    Write-Host "     功能：查看预约、确认预约、完成预约、拒绝预约" -ForegroundColor Gray
    Write-Host ""
    
    Write-Host "─────────────────────────────────────────────────" -ForegroundColor Gray
    Write-Host ""
    Write-Host "📚 API测试示例（使用Postman或curl）：" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "1. 创建预约（需要先登录获取token）：" -ForegroundColor Yellow
    Write-Host "   POST http://localhost:8080/api/appointment/create" -ForegroundColor Cyan
    Write-Host "   Headers: Authorization: Bearer {token}" -ForegroundColor Gray
    Write-Host "   Body: {" -ForegroundColor Gray
    Write-Host '     "merchantId": 1,' -ForegroundColor Gray
    Write-Host '     "motorcycleId": 1,' -ForegroundColor Gray
    Write-Host '     "appointmentTime": "2025-10-23T10:00:00",' -ForegroundColor Gray
    Write-Host '     "appointmentType": 2,' -ForegroundColor Gray
    Write-Host '     "serviceType": 1,' -ForegroundColor Gray
    Write-Host '     "serviceAddress": "测试地址",' -ForegroundColor Gray
    Write-Host '     "remark": "测试预约",' -ForegroundColor Gray
    Write-Host '     "serviceItems": []' -ForegroundColor Gray
    Write-Host "   }" -ForegroundColor Gray
    Write-Host ""
    Write-Host "2. 获取用户预约列表：" -ForegroundColor Yellow
    Write-Host "   GET http://localhost:8080/api/appointment/user/list?pageNum=1&pageSize=10" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "3. 获取附近商家（无需登录）：" -ForegroundColor Yellow
    Write-Host "   GET http://localhost:8080/api/public/merchants?merchantType=1" -ForegroundColor Cyan
    Write-Host ""
    
    Write-Host "─────────────────────────────────────────────────" -ForegroundColor Gray
    Write-Host ""
    Write-Host "🎯 完整测试流程：" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "步骤1：用户创建预约" -ForegroundColor Yellow
    Write-Host "  1. 用户登录（testuser456）" -ForegroundColor White
    Write-Host "  2. 查看附近商家" -ForegroundColor White
    Write-Host "  3. 选择商家并创建预约" -ForegroundColor White
    Write-Host "  4. 在'我的预约'中查看状态（待确认）" -ForegroundColor White
    Write-Host ""
    Write-Host "步骤2：商家确认预约" -ForegroundColor Yellow
    Write-Host "  1. 商家登录" -ForegroundColor White
    Write-Host "  2. 在'预约管理'中查看新预约" -ForegroundColor White
    Write-Host "  3. 点击'确认'按钮" -ForegroundColor White
    Write-Host "  4. 提供服务后点击'完成'按钮" -ForegroundColor White
    Write-Host ""
    Write-Host "步骤3：管理员监控" -ForegroundColor Yellow
    Write-Host "  1. 管理员登录（admin123）" -ForegroundColor White
    Write-Host "  2. 查看平台数据统计" -ForegroundColor White
    Write-Host "  3. 查看所有预约记录" -ForegroundColor White
    Write-Host "  4. 审核商家申请" -ForegroundColor White
    Write-Host ""
    
    Write-Host "─────────────────────────────────────────────────" -ForegroundColor Gray
    Write-Host ""
    Write-Host "📖 详细文档：" -ForegroundColor Cyan
    Write-Host "   • F:\redame\demo\✅功能完善完成指南.md" -ForegroundColor White
    Write-Host "   • F:\redame\demo\🎯功能完善计划.md" -ForegroundColor White
    Write-Host ""
    
    Write-Host "🌐 访问地址：" -ForegroundColor Cyan
    Write-Host "   • 前端：http://localhost:5173" -ForegroundColor Cyan
    Write-Host "   • 后端：http://localhost:8080" -ForegroundColor Cyan
    Write-Host ""
    
    Write-Host "🚀 正在打开浏览器..." -ForegroundColor Green
    Start-Sleep -Seconds 2
    Start-Process "http://localhost:5173"
    Write-Host "✅ 浏览器已打开！" -ForegroundColor Green
}

Write-Host ""
Write-Host "─────────────────────────────────────────────────" -ForegroundColor Gray
Write-Host "按任意键退出..." -ForegroundColor Gray
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")





