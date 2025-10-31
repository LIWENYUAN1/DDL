# 快速测试注册登录脚本
# 使用方法: 在另一个PowerShell窗口中运行此脚本，测试注册和登录

Write-Host "=== 快速测试注册登录 ===" -ForegroundColor Cyan

# 等待用户确认后端已启动
Write-Host "`n请确认后端已在另一个窗口启动完成，看到 'Started DemoApplication' 后按任意键继续..." -ForegroundColor Yellow
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")

# 生成随机用户
$randomNum = Get-Random -Maximum 9999
$username = "user$randomNum"
$phone = "139" + (Get-Random -Minimum 10000000 -Maximum 99999999)

Write-Host "`n1️⃣  测试注册..." -ForegroundColor Cyan
Write-Host "用户名: $username" -ForegroundColor White
Write-Host "手机号: $phone" -ForegroundColor White

$registerBody = @{
    username = $username
    password = "Test123456"
    confirmPassword = "Test123456"
    phone = $phone
    userType = 1
    code = "test"
} | ConvertTo-Json

try {
    $registerResult = Invoke-RestMethod -Uri "http://localhost:8080/auth/register" `
        -Method Post `
        -ContentType "application/json" `
        -Body $registerBody
    
    if ($registerResult.code -eq 200) {
        Write-Host "✅ 注册成功!" -ForegroundColor Green
        $registerSuccess = $true
    } else {
        Write-Host "❌ 注册失败" -ForegroundColor Red
        Write-Host "错误码: $($registerResult.code)" -ForegroundColor Yellow
        Write-Host "错误信息: $($registerResult.msg)" -ForegroundColor Yellow
        $registerSuccess = $false
    }
} catch {
    Write-Host "❌ 注册请求异常: $_" -ForegroundColor Red
    Write-Host "💡 请检查后端日志窗口查看详细错误" -ForegroundColor Yellow
    $registerSuccess = $false
}

# 如果注册成功，测试登录
if ($registerSuccess) {
    Write-Host "`n2️⃣  测试登录..." -ForegroundColor Cyan
    
    $loginBody = @{
        username = $username
        password = "Test123456"
        userType = 1
    } | ConvertTo-Json
    
    try {
        $loginResult = Invoke-RestMethod -Uri "http://localhost:8080/auth/login" `
            -Method Post `
            -ContentType "application/json" `
            -Body $loginBody
        
        if ($loginResult.code -eq 200) {
            Write-Host "✅ 登录成功!" -ForegroundColor Green
            Write-Host "`nToken: $($loginResult.data.token)" -ForegroundColor Cyan
            Write-Host "用户ID: $($loginResult.data.id)" -ForegroundColor Cyan
            Write-Host "用户名: $($loginResult.data.username)" -ForegroundColor Cyan
            Write-Host "手机号: $($loginResult.data.phone)" -ForegroundColor Cyan
        } else {
            Write-Host "❌ 登录失败" -ForegroundColor Red
            Write-Host "错误码: $($loginResult.code)" -ForegroundColor Yellow
            Write-Host "错误信息: $($loginResult.msg)" -ForegroundColor Yellow
        }
    } catch {
        Write-Host "❌ 登录请求异常: $_" -ForegroundColor Red
    }
}

Write-Host "`n=== 测试完成 ===" -ForegroundColor Cyan
Write-Host "提示: 请查看后端日志窗口了解详细信息" -ForegroundColor Yellow








