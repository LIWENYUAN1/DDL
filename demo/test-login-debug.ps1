# Debug Login Issue

Write-Host "Testing Login with Debug Info" -ForegroundColor Cyan
Write-Host ""

# Use the previously registered user
$testUsername = "testuser529"

Write-Host "Attempting login with username: $testUsername" -ForegroundColor Yellow
Write-Host ""

$loginData = @{
    username = $testUsername
    password = "123456"
    userType = 1
} | ConvertTo-Json

Write-Host "Login data: $loginData"
Write-Host ""

try {
    $loginResponse = Invoke-RestMethod -Uri "http://localhost:8080/auth/login" `
        -Method Post `
        -ContentType "application/json" `
        -Body $loginData `
        -ErrorAction Stop
    
    Write-Host "Login response received!" -ForegroundColor Green
    Write-Host "Full response:" -ForegroundColor Cyan
    Write-Host ($loginResponse | ConvertTo-Json -Depth 10)
    Write-Host ""
    
    # Check response structure
    Write-Host "Response code: $($loginResponse.code)" -ForegroundColor Yellow
    Write-Host "Response msg: $($loginResponse.msg)" -ForegroundColor Yellow
    Write-Host "Data exists: $($null -ne $loginResponse.data)" -ForegroundColor Yellow
    
    if ($null -ne $loginResponse.data) {
        Write-Host "Data type: $($loginResponse.data.GetType().Name)" -ForegroundColor Yellow
        Write-Host "Token exists: $($null -ne $loginResponse.data.token)" -ForegroundColor Yellow
        
        if ($null -ne $loginResponse.data.token) {
            $tokenLength = $loginResponse.data.token.Length
            Write-Host "Token length: $tokenLength" -ForegroundColor Yellow
            
            if ($tokenLength -gt 50) {
                Write-Host "Token preview: $($loginResponse.data.token.Substring(0, 50))..." -ForegroundColor Green
            } else {
                Write-Host "Token: $($loginResponse.data.token)" -ForegroundColor Green
            }
        } else {
            Write-Host "WARNING: Token is null!" -ForegroundColor Red
        }
        
        Write-Host "Username: $($loginResponse.data.username)" -ForegroundColor Green
        Write-Host "UserType: $($loginResponse.data.userType)" -ForegroundColor Green
    } else {
        Write-Host "ERROR: Response data is null!" -ForegroundColor Red
    }
    
} catch {
    Write-Host "Login FAILED!" -ForegroundColor Red
    Write-Host "Error: $($_.Exception.Message)" -ForegroundColor Red
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





