# 测试登录注册按钮
# 快速验证所有按钮是否正常跳转

Write-Host @"
╔═══════════════════════════════════════════════════════════╗
║                                                           ║
║     🔗 测试登录注册按钮                                  ║
║                                                           ║
║     验证所有按钮是否正常跳转                            ║
║                                                           ║
╚═══════════════════════════════════════════════════════════╝
"@ -ForegroundColor Cyan

Write-Host "`n【修复说明】" -ForegroundColor Yellow
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor DarkGray

Write-Host "`n✅ 已修复的按钮：" -ForegroundColor Green
Write-Host "   1. 顶部导航'登录'按钮 → /login" -ForegroundColor White
Write-Host "   2. 顶部导航'注册'按钮 → /register" -ForegroundColor White
Write-Host "   3. CTA'立即注册'按钮 → /register" -ForegroundColor White
Write-Host "   4. CTA'立即登录'按钮 → /login" -ForegroundColor White
Write-Host "   5. 页脚'用户登录'链接 → /login" -ForegroundColor White
Write-Host "   6. 页脚'用户注册'链接 → /register" -ForegroundColor White
Write-Host "   7. 页脚'商家登录'链接 → /shop/login" -ForegroundColor White

Write-Host "`n【检查服务状态】" -ForegroundColor Yellow
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor DarkGray

# 检查前端服务
$port5173 = $false
$port5175 = $false
$url = ""

Write-Host "`n检查前端服务..." -ForegroundColor Gray

try {
    $response = Invoke-WebRequest -Uri "http://localhost:5173" -Method Get -TimeoutSec 2 -ErrorAction Stop
    $port5173 = $true
    Write-Host "  ✅ 端口 5173 正在运行" -ForegroundColor Green
    $url = "http://localhost:5173"
} catch {
    Write-Host "  ❌ 端口 5173 未运行" -ForegroundColor Red
}

try {
    $response = Invoke-WebRequest -Uri "http://localhost:5175" -Method Get -TimeoutSec 2 -ErrorAction Stop
    $port5175 = $true
    Write-Host "  ✅ 端口 5175 正在运行" -ForegroundColor Green
    if (-not $url) {
        $url = "http://localhost:5175"
    }
} catch {
    Write-Host "  ❌ 端口 5175 未运行" -ForegroundColor Red
}

if (-not $port5173 -and -not $port5175) {
    Write-Host "`n⚠️  前端服务未运行！" -ForegroundColor Yellow
    Write-Host "`n请先启动前端服务：" -ForegroundColor Cyan
    Write-Host "  cd F:\redame\vue-project" -ForegroundColor Gray
    Write-Host "  npm run dev" -ForegroundColor Gray
    Write-Host "`n按任意键退出..." -ForegroundColor Gray
    $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
    exit 1
}

Write-Host "`n`n【测试步骤】" -ForegroundColor Yellow
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor DarkGray

Write-Host "`n即将打开首页，请按照以下步骤测试：" -ForegroundColor Cyan

Write-Host "`n📝 测试清单：" -ForegroundColor White
Write-Host ""
Write-Host "  1️⃣  顶部导航测试" -ForegroundColor Cyan
Write-Host "     ☐ 点击'登录'按钮" -ForegroundColor Gray
Write-Host "        → 应跳转到用户登录页 (/login)" -ForegroundColor DarkGray
Write-Host "        → 显示用户名、密码输入框" -ForegroundColor DarkGray
Write-Host ""
Write-Host "     ☐ 返回首页，点击'注册'按钮" -ForegroundColor Gray
Write-Host "        → 应跳转到注册页 (/register)" -ForegroundColor DarkGray
Write-Host "        → 显示注册表单" -ForegroundColor DarkGray

Write-Host "`n  2️⃣  CTA按钮测试" -ForegroundColor Cyan
Write-Host "     ☐ 滚动到功能介绍区域" -ForegroundColor Gray
Write-Host "     ☐ 点击'立即注册'按钮" -ForegroundColor Gray
Write-Host "        → 应跳转到注册页" -ForegroundColor DarkGray
Write-Host ""
Write-Host "     ☐ 返回首页" -ForegroundColor Gray
Write-Host "     ☐ 点击'立即登录'按钮" -ForegroundColor Gray
Write-Host "        → 应跳转到用户登录页" -ForegroundColor DarkGray

Write-Host "`n  3️⃣  页脚链接测试" -ForegroundColor Cyan
Write-Host "     ☐ 滚动到页脚" -ForegroundColor Gray
Write-Host "     ☐ 点击'用户登录'" -ForegroundColor Gray
Write-Host "        → 应跳转到 /login" -ForegroundColor DarkGray
Write-Host ""
Write-Host "     ☐ 返回首页" -ForegroundColor Gray
Write-Host "     ☐ 点击'用户注册'" -ForegroundColor Gray
Write-Host "        → 应跳转到 /register" -ForegroundColor DarkGray
Write-Host ""
Write-Host "     ☐ 返回首页" -ForegroundColor Gray
Write-Host "     ☐ 点击'商家登录'" -ForegroundColor Gray
Write-Host "        → 应跳转到 /shop/login" -ForegroundColor DarkGray

Write-Host "`n`n【快速验证路由】" -ForegroundColor Yellow
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor DarkGray

Write-Host "`n您也可以直接访问这些URL验证：" -ForegroundColor Cyan
Write-Host ""
Write-Host "  用户登录：  $url/login" -ForegroundColor White
Write-Host "  用户注册：  $url/register" -ForegroundColor White
Write-Host "  商家登录：  $url/shop/login" -ForegroundColor White
Write-Host "  管理员登录：$url/admin/login" -ForegroundColor White

Write-Host "`n`n【即将打开浏览器】" -ForegroundColor Yellow
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor DarkGray

Write-Host "`n💡 提示：" -ForegroundColor Cyan
Write-Host "   - 如果看不到更新，请按 Ctrl+F5 强制刷新" -ForegroundColor Gray
Write-Host "   - 测试时可以打开浏览器开发者工具（F12）" -ForegroundColor Gray
Write-Host "   - 在Network标签中查看路由跳转" -ForegroundColor Gray

Start-Sleep -Seconds 2

Write-Host "`n正在打开浏览器..." -ForegroundColor Cyan
Start-Process $url

Start-Sleep -Seconds 1

Write-Host "`n`n╔═══════════════════════════════════════════════════════════╗" -ForegroundColor Green
Write-Host "║                                                           ║" -ForegroundColor Green
Write-Host "║     ✅ 浏览器已打开！                                    ║" -ForegroundColor Green
Write-Host "║                                                           ║" -ForegroundColor Green
Write-Host "║     📋 开始测试：                                        ║" -ForegroundColor Green
Write-Host "║        1. 点击顶部'登录'按钮                            ║" -ForegroundColor Green
Write-Host "║        2. 确认跳转到用户登录页                          ║" -ForegroundColor Green
Write-Host "║        3. 测试其他所有按钮                              ║" -ForegroundColor Green
Write-Host "║                                                           ║" -ForegroundColor Green
Write-Host "║     ⚠️  重要：                                           ║" -ForegroundColor Green
Write-Host "║        如果看不到更新，按 Ctrl+F5 强制刷新！           ║" -ForegroundColor Green
Write-Host "║                                                           ║" -ForegroundColor Green
Write-Host "╚═══════════════════════════════════════════════════════════╝" -ForegroundColor Green

Write-Host "`n`n【预期结果】" -ForegroundColor Yellow
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor DarkGray

Write-Host "`n✅ 所有按钮都应该能正常跳转" -ForegroundColor Green
Write-Host "✅ 没有404错误" -ForegroundColor Green
Write-Host "✅ 登录页显示正常" -ForegroundColor Green
Write-Host "✅ 注册页显示正常" -ForegroundColor Green

Write-Host "`n如果遇到问题：" -ForegroundColor Yellow
Write-Host "  1. 检查浏览器控制台（F12 → Console）" -ForegroundColor Gray
Write-Host "  2. 查看是否有路由错误" -ForegroundColor Gray
Write-Host "  3. 确认页面文件是否存在" -ForegroundColor Gray
Write-Host "  4. 重启前端服务试试" -ForegroundColor Gray

Write-Host "`n详细说明文档：" -ForegroundColor Cyan
Write-Host "  F:\redame\demo\✅登录注册按钮已修复.md" -ForegroundColor White

Write-Host "`n按任意键退出..." -ForegroundColor Gray
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")


