# 摩托车服务平台 - 完整启动测试脚本

$ErrorActionPreference = "Continue"

Write-Host "============================================" -ForegroundColor Cyan
Write-Host "  摩托车服务平台 - 完整启动测试" -ForegroundColor Cyan
Write-Host "============================================`n" -ForegroundColor Cyan

# 1. 停止所有Java进程
Write-Host "1️⃣  停止旧的后端进程..." -ForegroundColor Yellow
Get-Process java -ErrorAction SilentlyContinue | Stop-Process -Force
Start-Sleep -Seconds 2
Write-Host "✅ 已停止" -ForegroundColor Green

# 2. 检查MySQL
Write-Host "`n2️⃣  检查MySQL数据库..." -ForegroundColor Yellow
try {
    $tables = mysql -uroot -p123456 -e "USE motorcycle_service_platform; SHOW TABLES;" 2>&1 | Select-String -Pattern "sys_user"
    if ($tables) {
        Write-Host "✅ MySQL连接正常，sys_user表存在" -ForegroundColor Green
    } else {
        Write-Host "❌ sys_user表不存在" -ForegroundColor Red
        exit
    }
} catch {
    Write-Host "❌ MySQL连接失败: $_" -ForegroundColor Red
    exit
}

# 3. 清理编译
Write-Host "`n3️⃣  清理并重新编译..." -ForegroundColor Yellow
cd F:\redame\demo
$compileOutput = .\mvnw.cmd clean compile -DskipTests 2>&1
if ($LASTEXITCODE -eq 0) {
    Write-Host "✅ 编译成功" -ForegroundColor Green
} else {
    Write-Host "❌ 编译失败，错误信息:" -ForegroundColor Red
    $compileOutput | Select-String -Pattern "ERROR" | ForEach-Object { Write-Host $_ -ForegroundColor Red }
    exit
}

# 4. 启动后端（前台模式，显示所有日志）
Write-Host "`n4️⃣  启动后端（前台模式）..." -ForegroundColor Yellow
Write-Host "💡 提示: 后端将在前台运行，按Ctrl+C可停止" -ForegroundColor Cyan
Write-Host "等待5秒后开始启动..." -ForegroundColor Cyan
Start-Sleep -Seconds 5

# 启动后端
.\mvnw.cmd spring-boot:run








