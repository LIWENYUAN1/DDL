# 清理并重启所有服务

Write-Host "🔄 开始清理并重启服务..." -ForegroundColor Cyan
Write-Host ""

# 停止后端服务
Write-Host "📌 停止后端服务 (端口 8080)..." -ForegroundColor Yellow
$backendPorts = @(8080)
foreach ($port in $backendPorts) {
    $process = Get-NetTCPConnection -LocalPort $port -ErrorAction SilentlyContinue | Select-Object -ExpandProperty OwningProcess -Unique
    if ($process) {
        Write-Host "   找到进程 PID: $process" -ForegroundColor Gray
        Stop-Process -Id $process -Force -ErrorAction SilentlyContinue
        Write-Host "   ✅ 已停止" -ForegroundColor Green
    } else {
        Write-Host "   ℹ️  端口未被占用" -ForegroundColor Gray
    }
}

Write-Host ""

# 停止前端服务
Write-Host "📌 停止前端服务 (端口 5173-5180)..." -ForegroundColor Yellow
$frontendPorts = @(5173, 5174, 5175, 5176, 5177, 5178, 5179, 5180)
$stoppedCount = 0
foreach ($port in $frontendPorts) {
    $process = Get-NetTCPConnection -LocalPort $port -ErrorAction SilentlyContinue | Select-Object -ExpandProperty OwningProcess -Unique
    if ($process) {
        Write-Host "   找到进程 PID: $process (端口 $port)" -ForegroundColor Gray
        Stop-Process -Id $process -Force -ErrorAction SilentlyContinue
        $stoppedCount++
    }
}
if ($stoppedCount -gt 0) {
    Write-Host "   ✅ 已停止 $stoppedCount 个前端进程" -ForegroundColor Green
} else {
    Write-Host "   ℹ️  没有前端进程在运行" -ForegroundColor Gray
}

Write-Host ""
Write-Host "⏳ 等待端口释放..." -ForegroundColor Yellow
Start-Sleep -Seconds 2

Write-Host ""
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Gray
Write-Host ""

# 启动后端
Write-Host "🚀 启动后端服务..." -ForegroundColor Cyan
Write-Host ""
Start-Process powershell -ArgumentList "-NoExit", "-Command", "cd F:\redame\demo; Write-Host '🔧 后端服务启动中...' -ForegroundColor Green; .\mvnw.cmd spring-boot:run"

Write-Host "   ✅ 后端启动命令已执行（新窗口）" -ForegroundColor Green
Write-Host "   ⏳ 请等待 10-20 秒让后端完全启动" -ForegroundColor Yellow

Write-Host ""

# 询问是否启动前端
$startFrontend = Read-Host "是否现在启动前端？(Y/N)"
if ($startFrontend -eq "Y" -or $startFrontend -eq "y") {
    Write-Host ""
    Write-Host "🚀 启动前端服务..." -ForegroundColor Cyan
    Write-Host ""
    Start-Process powershell -ArgumentList "-NoExit", "-Command", "cd F:\redame\vue-project; Write-Host '🎨 前端服务启动中...' -ForegroundColor Green; npm run dev"
    Write-Host "   ✅ 前端启动命令已执行（新窗口）" -ForegroundColor Green
    Write-Host ""
    Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Gray
    Write-Host ""
    Write-Host "📝 服务信息：" -ForegroundColor Cyan
    Write-Host "   🔧 后端：http://localhost:8080" -ForegroundColor White
    Write-Host "   🎨 前端：http://localhost:5173" -ForegroundColor White
    Write-Host ""
    Write-Host "⏳ 请等待 10-20 秒，然后在浏览器访问前端" -ForegroundColor Yellow
} else {
    Write-Host ""
    Write-Host "💡 稍后手动启动前端：" -ForegroundColor Yellow
    Write-Host "cd F:\redame\vue-project; npm run dev" -ForegroundColor White
}

Write-Host ""
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Gray
Write-Host ""
Write-Host "✅ 清理完成！" -ForegroundColor Green
Write-Host ""





