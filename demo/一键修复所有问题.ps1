# 一键修复所有问题

Write-Host "============================================" -ForegroundColor Cyan
Write-Host "    一键修复注册和预约功能" -ForegroundColor Cyan
Write-Host "============================================" -ForegroundColor Cyan
Write-Host ""

# 步骤1：停止后端
Write-Host "步骤1：停止现有后端进程..." -ForegroundColor Yellow
Get-Process -Name "java" -ErrorAction SilentlyContinue | Stop-Process -Force
Start-Sleep -Seconds 2
Write-Host "[完成]" -ForegroundColor Green
Write-Host ""

# 步骤2：提示执行SQL
Write-Host "步骤2：初始化数据库测试数据" -ForegroundColor Yellow
Write-Host "----------------------------------------------"
Write-Host "请在MySQL中执行以下操作：" -ForegroundColor White
Write-Host ""
Write-Host "1. 打开MySQL Workbench或命令行" -ForegroundColor Cyan
Write-Host "2. 执行以下SQL文件：" -ForegroundColor Cyan
Write-Host "   F:\redame\demo\INSERT_TEST_DATA.sql" -ForegroundColor Yellow
Write-Host ""
Write-Host "或者直接复制执行以下SQL：" -ForegroundColor Cyan
Write-Host "----------------------------------------------"
Write-Host @"
USE motorcycle_service_platform;

-- 插入测试商家
INSERT INTO merchant (id, merchant_name, contact_person, contact_phone, address, business_license, status, create_time, update_time)
VALUES (1, '阳光摩托车维修店', '张师傅', '13800138001', '北京市朝阳区建国路88号', 'BL2024001', 1, NOW(), NOW())
ON DUPLICATE KEY UPDATE merchant_name=VALUES(merchant_name), update_time=NOW();

-- 插入服务项目
INSERT INTO service_item (id, item_name, description, price, status, create_time, update_time)
VALUES 
(1, '常规保养', '更换机油、机滤、空滤，检查刹车系统', 200.00, 1, NOW(), NOW()),
(2, '刹车维护', '检查更换刹车片、刹车盘和刹车油', 300.00, 1, NOW(), NOW())
ON DUPLICATE KEY UPDATE item_name=VALUES(item_name), update_time=NOW();

-- 验证
SELECT * FROM merchant WHERE id = 1;
SELECT * FROM service_item WHERE id IN (1,2);
"@ -ForegroundColor White
Write-Host "----------------------------------------------"
Write-Host ""

$response = Read-Host "已经执行完SQL了吗？(输入 y 继续)"

if ($response -ne 'y' -and $response -ne 'Y') {
    Write-Host "请先执行SQL后再继续！" -ForegroundColor Red
    exit
}

Write-Host "[完成] 数据初始化完成" -ForegroundColor Green
Write-Host ""

# 步骤3：清理编译
Write-Host "步骤3：清理并编译后端..." -ForegroundColor Yellow
$compileOutput = & "F:\redame\demo\mvnw.cmd" clean compile 2>&1 | Out-String
if ($LASTEXITCODE -eq 0) {
    Write-Host "[成功] 编译成功" -ForegroundColor Green
} else {
    Write-Host "[失败] 编译失败" -ForegroundColor Red
    Write-Host "错误信息：" -ForegroundColor Yellow
    Write-Host ($compileOutput -split "`n" | Select-Object -Last 30 | Out-String)
    exit 1
}
Write-Host ""

# 步骤4：启动后端
Write-Host "步骤4：启动后端服务..." -ForegroundColor Yellow
Write-Host "后端将在新窗口中启动，请不要关闭那个窗口！" -ForegroundColor Cyan
Start-Process powershell -ArgumentList "-NoExit", "-Command", @"
Write-Host '后端服务启动中...' -ForegroundColor Cyan
Write-Host '请保持此窗口打开！' -ForegroundColor Yellow
Write-Host ''
cd F:\redame\demo
.\mvnw.cmd spring-boot:run
"@

Write-Host "[启动中] 后端在新窗口启动" -ForegroundColor Green
Write-Host ""

# 步骤5：等待后端就绪
Write-Host "步骤5：等待后端就绪..." -ForegroundColor Yellow
$maxAttempts = 12
$attempt = 0
$backendReady = $false

while ($attempt -lt $maxAttempts) {
    Start-Sleep -Seconds 5
    $attempt++
    Write-Host "  检查中... ($attempt/$maxAttempts)" -ForegroundColor White
    
    try {
        $healthResponse = Invoke-WebRequest -Uri "http://localhost:8080/actuator/health" -TimeoutSec 3 -ErrorAction Stop
        Write-Host "[成功] 后端已就绪！" -ForegroundColor Green
        $backendReady = $true
        break
    } catch {
        if ($attempt -eq $maxAttempts) {
            Write-Host "[超时] 后端启动时间过长" -ForegroundColor Red
            Write-Host "请检查后端窗口的错误信息" -ForegroundColor Yellow
        }
    }
}

if (-not $backendReady) {
    Write-Host ""
    Write-Host "后端未能在预期时间内启动" -ForegroundColor Red
    Write-Host "请查看后端窗口的错误信息" -ForegroundColor Yellow
    exit 1
}

Write-Host ""

# 步骤6：运行完整测试
Write-Host "步骤6：运行完整测试..." -ForegroundColor Yellow
Write-Host "============================================" -ForegroundColor Cyan
Write-Host ""

& "F:\redame\demo\test-register-and-appointment.ps1"

Write-Host ""
Write-Host "============================================" -ForegroundColor Cyan
Write-Host "    修复完成！" -ForegroundColor Green
Write-Host "============================================" -ForegroundColor Cyan
Write-Host ""

Write-Host "现在可以：" -ForegroundColor Cyan
Write-Host "  1. 访问前端：http://localhost:5175" -ForegroundColor White
Write-Host "  2. 测试注册功能" -ForegroundColor White
Write-Host "  3. 测试登录功能" -ForegroundColor White
Write-Host "  4. 测试预约功能" -ForegroundColor White
Write-Host ""
Write-Host "测试账号：" -ForegroundColor Cyan
Write-Host "  用户名：testuser850" -ForegroundColor White
Write-Host "  密码：123456" -ForegroundColor White
Write-Host ""




