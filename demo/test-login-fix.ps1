# Test Login and Register Fix

Write-Host "Testing Login and Register Functionality" -ForegroundColor Cyan
Write-Host ""

# Wait for backend to start
Write-Host "Waiting for backend service..." -ForegroundColor Yellow
Start-Sleep -Seconds 5

# Test 1: Register new user
Write-Host ""
Write-Host "Test 1: Register new user" -ForegroundColor Green
Write-Host "-----------------------------------"

$randomNum = Get-Random -Maximum 1000
$phoneNum = Get-Random -Minimum 10000000 -Maximum 99999999

$registerData = @{
    username = "testuser$randomNum"
    password = "123456"
    confirmPassword = "123456"
    phone = "138$phoneNum"
    userType = 1
} | ConvertTo-Json

Write-Host "Register data: $registerData"

try {
    $registerResponse = Invoke-RestMethod -Uri "http://localhost:8080/auth/register" `
        -Method Post `
        -ContentType "application/json" `
        -Body $registerData `
        -ErrorAction Stop
    
    Write-Host "Register SUCCESS!" -ForegroundColor Green
    Write-Host "Response: $($registerResponse | ConvertTo-Json)"
    
    # Extract username for login test
    $testUsername = "testuser$randomNum"
    
    # Test 2: Login
    Write-Host ""
    Write-Host "Test 2: User login" -ForegroundColor Green
    Write-Host "-----------------------------------"
    
    $loginData = @{
        username = $testUsername
        password = "123456"
        userType = 1
    } | ConvertTo-Json
    
    Write-Host "Login data: $loginData"
    
    Start-Sleep -Seconds 2
    
    $loginResponse = Invoke-RestMethod -Uri "http://localhost:8080/auth/login" `
        -Method Post `
        -ContentType "application/json" `
        -Body $loginData `
        -ErrorAction Stop
    
    Write-Host "Login SUCCESS!" -ForegroundColor Green
    $tokenPreview = $loginResponse.data.token.Substring(0, [Math]::Min(50, $loginResponse.data.token.Length))
    Write-Host "Token: $tokenPreview..."
    Write-Host "Username: $($loginResponse.data.username)"
    Write-Host "UserType: $($loginResponse.data.userType)"
    
    Write-Host ""
    Write-Host "All tests PASSED!" -ForegroundColor Green
    Write-Host ""
    Write-Host "Test account info:" -ForegroundColor Cyan
    Write-Host "   Username: $testUsername"
    Write-Host "   Password: 123456"
    Write-Host "   UserType: Normal User (1)"
    Write-Host ""
    
} catch {
    Write-Host "Test FAILED!" -ForegroundColor Red
    Write-Host "Error: $($_.Exception.Message)"
    Write-Host ""
    
    if ($_.Exception.Response) {
        try {
            $reader = New-Object System.IO.StreamReader($_.Exception.Response.GetResponseStream())
            $responseBody = $reader.ReadToEnd()
            Write-Host "Response body: $responseBody" -ForegroundColor Yellow
        } catch {
            Write-Host "Could not read response body" -ForegroundColor Yellow
        }
    }
}

Write-Host ""
Write-Host "Tips:" -ForegroundColor Yellow
Write-Host "   1. If register fails, check if backend is running"
Write-Host "   2. If login fails, check JWT configuration"
Write-Host "   3. You can now test login/register on frontend"
Write-Host ""
Write-Host "Frontend URL: http://localhost:5175" -ForegroundColor Cyan
Write-Host ""
