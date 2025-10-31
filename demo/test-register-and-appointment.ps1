# Test Register and Appointment Issues

Write-Host "======================================" -ForegroundColor Cyan
Write-Host " Testing Register and Appointment" -ForegroundColor Cyan
Write-Host "======================================" -ForegroundColor Cyan
Write-Host ""

# Test 1: Register
Write-Host "Test 1: Register new user" -ForegroundColor Yellow
Write-Host "--------------------------------------"

$randomNum = Get-Random -Maximum 10000
$phoneNum = Get-Random -Minimum 10000000 -Maximum 99999999

$registerData = @{
    username = "newuser$randomNum"
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
    
    Write-Host "[SUCCESS] Register successful!" -ForegroundColor Green
    Write-Host "Response: $($registerResponse | ConvertTo-Json)"
    
    $newUsername = "newuser$randomNum"
    
    # Test 2: Login with new user
    Write-Host ""
    Write-Host "Test 2: Login with new user" -ForegroundColor Yellow
    Write-Host "--------------------------------------"
    
    $loginData = @{
        username = $newUsername
        password = "123456"
        userType = 1
    } | ConvertTo-Json
    
    Start-Sleep -Seconds 1
    
    $loginResponse = Invoke-RestMethod -Uri "http://localhost:8080/auth/login" `
        -Method Post `
        -ContentType "application/json" `
        -Body $loginData `
        -ErrorAction Stop
    
    Write-Host "[SUCCESS] Login successful!" -ForegroundColor Green
    $token = $loginResponse.data.token
    $userId = $loginResponse.data.id
    Write-Host "Token obtained, User ID: $userId"
    
    # Test 3: Create Appointment
    Write-Host ""
    Write-Host "Test 3: Create appointment" -ForegroundColor Yellow
    Write-Host "--------------------------------------"
    
    $appointmentData = @{
        merchantId = 1
        motorcycleModel = "Test Bike Model"
        licensePlate = "TEST$randomNum"
        contactPhone = "138$phoneNum"
        description = "Test appointment"
        appointmentTime = (Get-Date).AddDays(1).ToString("yyyy-MM-dd HH:mm:ss")
        serviceItemId = 1
        appointmentType = 2
        serviceType = 1
        serviceAddress = "Test Address"
        remark = "Auto test"
    } | ConvertTo-Json
    
    Write-Host "Appointment data: $appointmentData"
    
    $headers = @{
        "Authorization" = "Bearer $token"
        "Content-Type" = "application/json"
    }
    
    $appointmentResponse = Invoke-RestMethod -Uri "http://localhost:8080/api/appointment/create" `
        -Method Post `
        -Headers $headers `
        -Body $appointmentData `
        -ErrorAction Stop
    
    Write-Host "[SUCCESS] Appointment created!" -ForegroundColor Green
    Write-Host "Response: $($appointmentResponse | ConvertTo-Json)"
    Write-Host "Appointment ID: $($appointmentResponse.data)"
    
    Write-Host ""
    Write-Host "========================================" -ForegroundColor Green
    Write-Host " ALL TESTS PASSED!" -ForegroundColor Green
    Write-Host "========================================" -ForegroundColor Green
    
} catch {
    Write-Host ""
    Write-Host "[FAILED] Test failed!" -ForegroundColor Red
    Write-Host "Error: $($_.Exception.Message)" -ForegroundColor Red
    Write-Host ""
    
    if ($_.Exception.Response) {
        try {
            $reader = New-Object System.IO.StreamReader($_.Exception.Response.GetResponseStream())
            $responseBody = $reader.ReadToEnd()
            Write-Host "Response body:" -ForegroundColor Yellow
            Write-Host $responseBody
            
            # Try to parse as JSON
            try {
                $errorJson = $responseBody | ConvertFrom-Json
                Write-Host ""
                Write-Host "Error details:" -ForegroundColor Yellow
                Write-Host "  Code: $($errorJson.code)"
                Write-Host "  Message: $($errorJson.msg)"
            } catch {
                # Not JSON format
            }
        } catch {
            Write-Host "Could not read error response" -ForegroundColor Yellow
        }
    }
    
    Write-Host ""
    Write-Host "Debug Info:" -ForegroundColor Cyan
    Write-Host "  Backend URL: http://localhost:8080"
    Write-Host "  Check if backend is running"
    Write-Host "  Check backend console for error logs"
}

Write-Host ""




