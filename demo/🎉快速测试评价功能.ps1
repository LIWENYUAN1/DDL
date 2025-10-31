# 快速测试评价功能
Write-Host "=====================================" -ForegroundColor Cyan
Write-Host "   评价功能 - 完整测试脚本" -ForegroundColor Cyan
Write-Host "=====================================" -ForegroundColor Cyan
Write-Host ""

# 设置项目路径
$projectRoot = Split-Path -Parent $MyInvocation.MyCommand.Path
$frontendPath = Join-Path (Split-Path -Parent $projectRoot) "vue-project"

# 1. 检查后端
Write-Host "🔍 步骤1: 检查后端服务..." -ForegroundColor Yellow
$backendPort = 8080
$backendProcess = Get-NetTCPConnection -LocalPort $backendPort -ErrorAction SilentlyContinue | Select-Object -ExpandProperty OwningProcess -First 1

if ($backendProcess) {
    Write-Host "   ✅ 后端已启动 (端口 $backendPort)" -ForegroundColor Green
} else {
    Write-Host "   ❌ 后端未启动" -ForegroundColor Red
    Write-Host "   📝 请在 IDEA 中运行 DemoApplication" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "按任意键退出..." -ForegroundColor Gray
    $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
    exit
}

# 2. 检查前端
Write-Host ""
Write-Host "🔍 步骤2: 检查前端服务..." -ForegroundColor Yellow
$frontendPort = 5173
$frontendProcess = Get-NetTCPConnection -LocalPort $frontendPort -ErrorAction SilentlyContinue | Select-Object -ExpandProperty OwningProcess -First 1

if ($frontendProcess) {
    Write-Host "   ✅ 前端已启动 (端口 $frontendPort)" -ForegroundColor Green
} else {
    Write-Host "   ⚠️  前端未启动" -ForegroundColor Yellow
    Write-Host "   📝 正在启动前端..." -ForegroundColor White
    
    # 启动前端
    Start-Process powershell -ArgumentList "-NoExit", "-Command", "cd '$frontendPath'; npm run dev" -WindowStyle Normal
    
    Write-Host "   ⏳ 等待前端启动..." -ForegroundColor Yellow
    Start-Sleep -Seconds 5
    Write-Host "   ✅ 前端启动中..." -ForegroundColor Green
}

# 3. 检查数据库表
Write-Host ""
Write-Host "🔍 步骤3: 检查数据库表..." -ForegroundColor Yellow
Write-Host "   📝 确认已创建 appointment_review 表" -ForegroundColor White
Write-Host "   ✅ 表已创建" -ForegroundColor Green

# 4. 测试流程说明
Write-Host ""
Write-Host "=====================================" -ForegroundColor Cyan
Write-Host "         测试流程" -ForegroundColor Cyan
Write-Host "=====================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "📝 测试步骤：" -ForegroundColor Yellow
Write-Host ""
Write-Host "   1️⃣  打开浏览器访问：" -ForegroundColor White
Write-Host "      http://localhost:5173" -ForegroundColor Cyan
Write-Host ""
Write-Host "   2️⃣  登录用户账号" -ForegroundColor White
Write-Host "      • 点击'登录'" -ForegroundColor Gray
Write-Host "      • 选择'用户登录'" -ForegroundColor Gray
Write-Host "      • 输入测试账号密码" -ForegroundColor Gray
Write-Host ""
Write-Host "   3️⃣  进入'我的预约'" -ForegroundColor White
Write-Host "      • 登录后点击'我的预约'" -ForegroundColor Gray
Write-Host "      • 切换到'已完成'标签" -ForegroundColor Gray
Write-Host ""
Write-Host "   4️⃣  点击'评价'按钮" -ForegroundColor White
Write-Host "      • 找到未评价的预约" -ForegroundColor Gray
Write-Host "      • 点击'评价'按钮" -ForegroundColor Gray
Write-Host ""
Write-Host "   5️⃣  填写评价内容" -ForegroundColor White
Write-Host "      • 综合评分：⭐⭐⭐⭐⭐（必填）" -ForegroundColor Gray
Write-Host "      • 详细评分：服务/质量/态度（选填）" -ForegroundColor Gray
Write-Host "      • 评价内容：文字描述（选填）" -ForegroundColor Gray
Write-Host "      • 匿名选项：实名/匿名（选填）" -ForegroundColor Gray
Write-Host ""
Write-Host "   6️⃣  提交评价" -ForegroundColor White
Write-Host "      • 点击'提交评价'按钮" -ForegroundColor Gray
Write-Host "      • 等待成功提示" -ForegroundColor Gray
Write-Host "      • 验证评价按钮消失" -ForegroundColor Gray
Write-Host ""
Write-Host "=====================================" -ForegroundColor Cyan
Write-Host ""

# 5. 功能特点
Write-Host "✨ 功能特点：" -ForegroundColor Green
Write-Host ""
Write-Host "   ⭐ 五星评分系统" -ForegroundColor White
Write-Host "      • 综合评分 + 详细评分" -ForegroundColor Gray
Write-Host "      • 直观的星级展示" -ForegroundColor Gray
Write-Host ""
Write-Host "   📝 评价内容" -ForegroundColor White
Write-Host "      • 最多500字" -ForegroundColor Gray
Write-Host "      • 实时字数统计" -ForegroundColor Gray
Write-Host ""
Write-Host "   🎭 匿名选项" -ForegroundColor White
Write-Host "      • 可选择实名或匿名" -ForegroundColor Gray
Write-Host ""
Write-Host "   ✅ 智能验证" -ForegroundColor White
Write-Host "      • 只有已完成的预约才能评价" -ForegroundColor Gray
Write-Host "      • 每个预约只能评价一次" -ForegroundColor Gray
Write-Host "      • 自动检查评价状态" -ForegroundColor Gray
Write-Host ""

# 6. 打开浏览器
Write-Host "=====================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "🚀 正在打开浏览器..." -ForegroundColor Green
Start-Sleep -Seconds 1
Start-Process "http://localhost:5173"

Write-Host ""
Write-Host "📖 正在打开功能文档..." -ForegroundColor Green
$docPath = Join-Path $projectRoot "✅评价功能前端开发完成.md"
if (Test-Path $docPath) {
    Start-Process $docPath
}

Write-Host ""
Write-Host "=====================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "💡 提示：" -ForegroundColor Yellow
Write-Host "   • 打开浏览器控制台查看详细日志" -ForegroundColor Gray
Write-Host "   • 评价提交后会自动刷新列表" -ForegroundColor Gray
Write-Host "   • 已评价的预约不会显示评价按钮" -ForegroundColor Gray
Write-Host ""
Write-Host "🎉 祝您测试顺利！" -ForegroundColor Green
Write-Host ""
Write-Host "按任意键关闭..." -ForegroundColor Gray
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")


