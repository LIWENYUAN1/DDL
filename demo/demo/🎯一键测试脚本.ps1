# 摩托车服务平台 - 一键测试脚本

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  摩托车服务平台 - 一键测试脚本" -ForegroundColor Cyan
Write-Host "========================================`n" -ForegroundColor Cyan

# 1. 检查后端状态
Write-Host "1️⃣  检查后端状态..." -ForegroundColor Yellow
$port8080 = netstat -ano | findstr ":8080" | findstr "LISTENING"
if ($port8080) {
    Write-Host "✅ 后端正在运行 (端口 8080)" -ForegroundColor Green
} else {
    Write-Host "❌ 后端未运行，正在启动..." -ForegroundColor Red
    Start-Process powershell -ArgumentList "-NoExit", "-Command", "cd F:\redame\demo; .\mvnw.cmd spring-boot:run"
    Write-Host "⏳ 等待后端启动 (30秒)..." -ForegroundColor Yellow
    Start-Sleep -Seconds 30
}

# 2. 检查MySQL连接
Write-Host "`n2️⃣  检查MySQL连接..." -ForegroundColor Yellow
try {
    $mysqlTest = mysql -uroot -p123456 -e "SELECT 1;" 2>&1
    if ($LASTEXITCODE -eq 0) {
        Write-Host "✅ MySQL连接正常" -ForegroundColor Green
    } else {
        Write-Host "❌ MySQL连接失败，请检查MySQL服务是否启动" -ForegroundColor Red
        exit
    }
} catch {
    Write-Host "❌ MySQL连接失败: $_" -ForegroundColor Red
    exit
}

# 3. 测试注册接口
Write-Host "`n3️⃣  测试注册接口..." -ForegroundColor Yellow
$randomUser = "testuser" + (Get-Random -Maximum 9999)
$randomPhone = "139" + (Get-Random -Minimum 10000000 -Maximum 99999999)

$registerBody = @{
    username = $randomUser
    password = "Test123456"
    confirmPassword = "Test123456"
    phone = $randomPhone
    userType = 1
    code = "test"
} | ConvertTo-Json

Write-Host "注册信息: 用户名=$randomUser, 手机号=$randomPhone" -ForegroundColor Cyan

try {
    $registerResult = Invoke-RestMethod -Uri "http://localhost:8080/auth/register" `
        -Method Post `
        -ContentType "application/json" `
        -Body $registerBody `
        -ErrorAction Stop
    
    if ($registerResult.code -eq 200) {
        Write-Host "✅ 注册成功!" -ForegroundColor Green
        $registerSuccess = $true
    } else {
        Write-Host "❌ 注册失败: code=$($registerResult.code), msg=$($registerResult.msg)" -ForegroundColor Red
        $registerSuccess = $false
    }
} catch {
    Write-Host "❌ 注册请求失败: $_" -ForegroundColor Red
    Write-Host "💡 提示: 请查看后端日志窗口查看详细错误" -ForegroundColor Yellow
    $registerSuccess = $false
}

# 4. 测试登录接口（如果注册成功）
if ($registerSuccess) {
    Write-Host "`n4️⃣  测试登录接口..." -ForegroundColor Yellow
    $loginBody = @{
        username = $randomUser
        password = "Test123456"
        userType = 1
    } | ConvertTo-Json
    
    try {
        $loginResult = Invoke-RestMethod -Uri "http://localhost:8080/auth/login" `
            -Method Post `
            -ContentType "application/json" `
            -Body $loginBody `
            -ErrorAction Stop
        
        if ($loginResult.code -eq 200) {
            Write-Host "✅ 登录成功!" -ForegroundColor Green
            Write-Host "Token: $($loginResult.data.token)" -ForegroundColor Cyan
            Write-Host "用户信息:" -ForegroundColor Cyan
            $loginResult.data | Format-List
        } else {
            Write-Host "❌ 登录失败: code=$($loginResult.code), msg=$($loginResult.msg)" -ForegroundColor Red
        }
    } catch {
        Write-Host "❌ 登录请求失败: $_" -ForegroundColor Red
    }
} else {
    Write-Host "`n4️⃣  跳过登录测试（注册失败）" -ForegroundColor Yellow
}

# 5. 测试admin账号登录
Write-Host "`n5️⃣  测试admin账号登录..." -ForegroundColor Yellow
$adminLoginBody = '{"username":"admin","password":"admin123","userType":3}'

try {
    $adminResult = Invoke-RestMethod -Uri "http://localhost:8080/auth/login" `
        -Method Post `
        -ContentType "application/json" `
        -Body $adminLoginBody `
        -ErrorAction Stop
    
    if ($adminResult.code -eq 200) {
        Write-Host "✅ Admin登录成功!" -ForegroundColor Green
    } else {
        Write-Host "❌ Admin登录失败: code=$($adminResult.code), msg=$($adminResult.msg)" -ForegroundColor Red
    }
} catch {
    Write-Host "❌ Admin登录请求失败: $_" -ForegroundColor Red
}

Write-Host "`n========================================" -ForegroundColor Cyan
Write-Host "  测试完成" -ForegroundColor Cyan
Write-Host "========================================`n" -ForegroundColor Cyan

Write-Host "💡 提示:" -ForegroundColor Yellow
Write-Host "  - 如果测试失败，请查看后端日志窗口" -ForegroundColor White
Write-Host "  - 后端日志包含详细的错误信息" -ForegroundColor White
Write-Host "  - 可以使用 Alt+Tab 切换到后端日志窗口查看" -ForegroundColor White















