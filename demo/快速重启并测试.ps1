# 快速重启后端并测试预约功能
# 使用方法：右键点击此文件 → 使用PowerShell运行

Write-Host "═══════════════════════════════════════" -ForegroundColor Cyan
Write-Host "    🔧 快速重启后端服务" -ForegroundColor Yellow
Write-Host "═══════════════════════════════════════" -ForegroundColor Cyan
Write-Host ""

# 进入项目目录
Set-Location -Path "F:\redame\demo"

Write-Host "📍 当前目录: $(Get-Location)" -ForegroundColor Gray
Write-Host ""

# 第1步：清理旧的8080端口进程
Write-Host "🔍 检查8080端口..." -ForegroundColor White
$port = 8080
$connections = Get-NetTCPConnection -LocalPort $port -ErrorAction SilentlyContinue

if ($connections) {
    $processIds = $connections | Select-Object -ExpandProperty OwningProcess -Unique
    foreach ($pid in $processIds) {
        Write-Host "   终止进程 $pid..." -ForegroundColor Yellow
        Stop-Process -Id $pid -Force -ErrorAction SilentlyContinue
    }
    Start-Sleep -Seconds 2
    Write-Host "   ✅ 端口已清理" -ForegroundColor Green
} else {
    Write-Host "   ✅ 端口未被占用" -ForegroundColor Green
}
Write-Host ""

# 第2步：清理编译
Write-Host "🧹 清理编译缓存..." -ForegroundColor White
.\mvnw.cmd clean | Out-Null
Write-Host "   ✅ 清理完成" -ForegroundColor Green
Write-Host ""

# 第3步：编译项目
Write-Host "🔨 编译项目..." -ForegroundColor White
$compileOutput = .\mvnw.cmd compile 2>&1
$compileSuccess = $LASTEXITCODE -eq 0

if ($compileSuccess) {
    Write-Host "   ✅ 编译成功" -ForegroundColor Green
} else {
    Write-Host "   ❌ 编译失败" -ForegroundColor Red
    Write-Host ""
    Write-Host "编译输出（最后20行）：" -ForegroundColor Yellow
    $compileOutput | Select-Object -Last 20
    Write-Host ""
    Write-Host "按任意键退出..." -ForegroundColor Gray
    $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
    exit 1
}
Write-Host ""

# 第4步：启动服务
Write-Host "═══════════════════════════════════════" -ForegroundColor Green
Write-Host "    🚀 启动后端服务..." -ForegroundColor Green
Write-Host "═══════════════════════════════════════" -ForegroundColor Green
Write-Host ""
Write-Host "提示：" -ForegroundColor Cyan
Write-Host "  - 看到 'Started DemoApplication' 表示启动成功" -ForegroundColor White
Write-Host "  - 按 Ctrl+C 可以停止服务" -ForegroundColor White
Write-Host "  - 启动后请在浏览器中测试预约功能" -ForegroundColor White
Write-Host ""
Write-Host "正在启动，请稍候..." -ForegroundColor Yellow
Write-Host ""

# 启动服务
.\mvnw.cmd spring-boot:run



