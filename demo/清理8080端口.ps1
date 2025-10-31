# 清理8080端口占用进程
# 使用方法：右键点击此文件 → 使用PowerShell运行

Write-Host "═══════════════════════════════════════" -ForegroundColor Cyan
Write-Host "    🔧 清理8080端口占用工具" -ForegroundColor Yellow
Write-Host "═══════════════════════════════════════" -ForegroundColor Cyan
Write-Host ""

$port = 8080

# 查找占用端口的进程
Write-Host "🔍 正在检查端口 $port..." -ForegroundColor White

$connections = Get-NetTCPConnection -LocalPort $port -ErrorAction SilentlyContinue

if ($connections) {
    $processIds = $connections | Select-Object -ExpandProperty OwningProcess -Unique
    
    Write-Host "⚠️  发现以下进程占用端口 ${port}:" -ForegroundColor Yellow
    Write-Host ""
    
    foreach ($pid in $processIds) {
        $process = Get-Process -Id $pid -ErrorAction SilentlyContinue
        if ($process) {
            Write-Host "   进程名称: $($process.ProcessName)" -ForegroundColor White
            Write-Host "   进程ID:   $pid" -ForegroundColor White
            Write-Host "   启动时间: $($process.StartTime)" -ForegroundColor Gray
            Write-Host ""
            
            # 询问是否终止
            $confirm = Read-Host "是否终止此进程? (Y/N)"
            if ($confirm -eq 'Y' -or $confirm -eq 'y') {
                try {
                    Stop-Process -Id $pid -Force
                    Write-Host "   ✅ 成功终止进程 $pid" -ForegroundColor Green
                } catch {
                    Write-Host "   ❌ 终止进程失败: $($_.Exception.Message)" -ForegroundColor Red
                }
            } else {
                Write-Host "   ⏭️  跳过进程 $pid" -ForegroundColor Gray
            }
            Write-Host ""
        }
    }
    
    # 再次检查
    Start-Sleep -Seconds 1
    $stillOccupied = Get-NetTCPConnection -LocalPort $port -ErrorAction SilentlyContinue
    
    if (-not $stillOccupied) {
        Write-Host "═══════════════════════════════════════" -ForegroundColor Green
        Write-Host "    ✅ 端口 $port 现在已空闲！" -ForegroundColor Green
        Write-Host "═══════════════════════════════════════" -ForegroundColor Green
        Write-Host ""
        Write-Host "您现在可以在IDEA中启动项目了！" -ForegroundColor Cyan
    } else {
        Write-Host "═══════════════════════════════════════" -ForegroundColor Yellow
        Write-Host "    ⚠️  端口 $port 仍被占用" -ForegroundColor Yellow
        Write-Host "═══════════════════════════════════════" -ForegroundColor Yellow
        Write-Host ""
        Write-Host "请手动检查并终止相关进程" -ForegroundColor White
    }
    
} else {
    Write-Host "═══════════════════════════════════════" -ForegroundColor Green
    Write-Host "    ✅ 端口 $port 未被占用！" -ForegroundColor Green
    Write-Host "═══════════════════════════════════════" -ForegroundColor Green
    Write-Host ""
    Write-Host "您可以直接在IDEA中启动项目！" -ForegroundColor Cyan
}

Write-Host ""
Write-Host "按任意键退出..." -ForegroundColor Gray
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")




