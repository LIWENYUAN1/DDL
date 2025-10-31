# 🎨 查看摩托车平台新首页

Write-Host ""
Write-Host "═══════════════════════════════════════════" -ForegroundColor Cyan
Write-Host "    🏍️  摩托车服务平台 - 新首页演示" -ForegroundColor Green
Write-Host "═══════════════════════════════════════════" -ForegroundColor Cyan
Write-Host ""

Write-Host "📋 新首页包含的内容：" -ForegroundColor Yellow
Write-Host "   ✅ 平台介绍和数据统计" -ForegroundColor White
Write-Host "   ✅ 6种摩托车类型展示（街车、跑车、巡航车、越野车、复古车、踏板车）" -ForegroundColor White
Write-Host "   ✅ 动态SVG图标和悬停效果" -ForegroundColor White
Write-Host "   ✅ 服务特色展示" -ForegroundColor White
Write-Host "   ✅ 完整的登录注册入口（功能不受影响）" -ForegroundColor White
Write-Host "   ✅ 响应式设计（支持手机、平板、桌面）" -ForegroundColor White
Write-Host ""

# 检查前端是否正在运行
Write-Host "🔍 检查前端服务状态..." -ForegroundColor Cyan

$frontendRunning = $false
try {
    $response = Invoke-WebRequest -Uri "http://localhost:5173" -TimeoutSec 2 -UseBasicParsing -ErrorAction SilentlyContinue
    if ($response.StatusCode -eq 200) {
        $frontendRunning = $true
    }
} catch {
    $frontendRunning = $false
}

if ($frontendRunning) {
    Write-Host "✅ 前端服务正在运行！" -ForegroundColor Green
    Write-Host ""
    Write-Host "🌐 访问地址：" -ForegroundColor Yellow
    Write-Host "   http://localhost:5173" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "💡 使用提示：" -ForegroundColor Yellow
    Write-Host "   1. 滚动页面查看所有内容" -ForegroundColor White
    Write-Host "   2. 鼠标悬停在卡片上查看动态效果" -ForegroundColor White
    Write-Host "   3. 调整浏览器窗口大小查看响应式效果" -ForegroundColor White
    Write-Host "   4. 点击登录/注册按钮测试跳转功能" -ForegroundColor White
    Write-Host ""
    Write-Host "🚀 正在打开浏览器..." -ForegroundColor Green
    Start-Sleep -Seconds 2
    Start-Process "http://localhost:5173"
    Write-Host "✅ 浏览器已打开！" -ForegroundColor Green
} else {
    Write-Host "❌ 前端服务未运行！" -ForegroundColor Red
    Write-Host ""
    Write-Host "🔧 正在启动前端服务..." -ForegroundColor Yellow
    Write-Host ""
    
    # 启动前端
    Write-Host "📦 切换到前端目录..." -ForegroundColor Cyan
    Set-Location "F:\redame\vue-project"
    
    Write-Host "🚀 启动开发服务器..." -ForegroundColor Cyan
    Write-Host ""
    Write-Host "提示：服务启动后，浏览器会自动打开" -ForegroundColor Yellow
    Write-Host "      访问地址：http://localhost:5173" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "按 Ctrl+C 可以停止服务" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "─────────────────────────────────────────" -ForegroundColor Gray
    
    # 运行开发服务器
    npm run dev
}

Write-Host ""
Write-Host "─────────────────────────────────────────" -ForegroundColor Gray
Write-Host "按任意键退出..." -ForegroundColor Gray
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")





