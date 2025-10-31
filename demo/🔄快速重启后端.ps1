# 快速重启后端服务
Write-Host "=====================================" -ForegroundColor Cyan
Write-Host "   评价功能 - 快速重启后端服务" -ForegroundColor Cyan
Write-Host "=====================================" -ForegroundColor Cyan
Write-Host ""

# 1. 检查8080端口是否被占用
Write-Host "🔍 检查端口占用情况..." -ForegroundColor Yellow
$port = 8080
$process = Get-NetTCPConnection -LocalPort $port -ErrorAction SilentlyContinue | Select-Object -ExpandProperty OwningProcess -First 1

if ($process) {
    Write-Host "⚠️  端口 $port 被进程 $process 占用" -ForegroundColor Red
    Write-Host "🔧 正在释放端口..." -ForegroundColor Yellow
    Stop-Process -Id $process -Force -ErrorAction SilentlyContinue
    Start-Sleep -Seconds 2
    Write-Host "✅ 端口已释放" -ForegroundColor Green
} else {
    Write-Host "✅ 端口 $port 空闲" -ForegroundColor Green
}

Write-Host ""
Write-Host "=====================================" -ForegroundColor Cyan
Write-Host "         下一步操作" -ForegroundColor Cyan
Write-Host "=====================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "📝 请在 IDEA 中执行以下步骤：" -ForegroundColor Yellow
Write-Host ""
Write-Host "   1️⃣  刷新 Maven 项目" -ForegroundColor White
Write-Host "      点击右上角 Maven 图标 → 刷新按钮" -ForegroundColor Gray
Write-Host ""
Write-Host "   2️⃣  重新运行 DemoApplication" -ForegroundColor White
Write-Host "      右键 DemoApplication.java → Run" -ForegroundColor Gray
Write-Host ""
Write-Host "   3️⃣  看到以下日志表示成功：" -ForegroundColor White
Write-Host "      'Started DemoApplication in X.XXX seconds'" -ForegroundColor Green
Write-Host ""
Write-Host "=====================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "💡 提示：修复了 javax → jakarta 依赖问题" -ForegroundColor Yellow
Write-Host ""
Write-Host "📖 详细说明请查看：" -ForegroundColor Cyan
Write-Host "   ✅依赖问题已修复-立即重启.md" -ForegroundColor White
Write-Host ""

# 打开说明文档
$docPath = Join-Path $PSScriptRoot "✅依赖问题已修复-立即重启.md"
if (Test-Path $docPath) {
    Write-Host "🚀 正在打开说明文档..." -ForegroundColor Green
    Start-Process $docPath
}

Write-Host ""
Write-Host "按任意键关闭..." -ForegroundColor Gray
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")


