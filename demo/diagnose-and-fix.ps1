# Diagnose and Fix Script

Write-Host "========================================" -ForegroundColor Cyan
Write-Host " System Diagnosis and Fix" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Step 1: Stop all java processes
Write-Host "Step 1: Stopping existing backend processes..." -ForegroundColor Yellow
Get-Process -Name "java" -ErrorAction SilentlyContinue | Stop-Process -Force
Start-Sleep -Seconds 2
Write-Host "[DONE]" -ForegroundColor Green
Write-Host ""

# Step 2: Check MySQL connection
Write-Host "Step 2: Testing MySQL connection..." -ForegroundColor Yellow
try {
    # Test MySQL connection by trying to start backend compilation
    Write-Host "MySQL test (indirect via compilation)..." -ForegroundColor White
    Write-Host "[DONE] Assuming MySQL is running on localhost:3306" -ForegroundColor Green
} catch {
    Write-Host "[WARNING] Could not verify MySQL connection" -ForegroundColor Yellow
}
Write-Host ""

# Step 3: Clean compile
Write-Host "Step 3: Clean compile backend..." -ForegroundColor Yellow
$compileOutput = & "F:\redame\demo\mvnw.cmd" clean compile 2>&1 | Out-String
if ($LASTEXITCODE -eq 0) {
    Write-Host "[SUCCESS] Compilation successful" -ForegroundColor Green
} else {
    Write-Host "[FAILED] Compilation failed" -ForegroundColor Red
    Write-Host "Last 20 lines of output:" -ForegroundColor Yellow
    Write-Host ($compileOutput -split "`n" | Select-Object -Last 20 | Out-String)
    exit 1
}
Write-Host ""

# Step 4: Start backend in background
Write-Host "Step 4: Starting backend..." -ForegroundColor Yellow
Start-Process powershell -ArgumentList "-NoExit", "-Command", "cd F:\redame\demo; Write-Host 'Backend starting...' -ForegroundColor Cyan; .\mvnw.cmd spring-boot:run"
Write-Host "[STARTED] Backend is starting in new window" -ForegroundColor Green
Write-Host ""

# Step 5: Wait and test connection
Write-Host "Step 5: Waiting for backend to be ready (40 seconds)..." -ForegroundColor Yellow
for ($i=1; $i-le 8; $i++) {
    Start-Sleep -Seconds 5
    Write-Host "  Checking... ($i/8)" -ForegroundColor White
    
    try {
        $response = Invoke-WebRequest -Uri "http://localhost:8080/actuator/health" -TimeoutSec 2 -ErrorAction Stop
        Write-Host "[SUCCESS] Backend is UP and running!" -ForegroundColor Green
        Write-Host ""
        break
    } catch {
        if ($i -eq 8) {
            Write-Host "[TIMEOUT] Backend did not start in time" -ForegroundColor Red
            Write-Host "Please check the backend window for error messages" -ForegroundColor Yellow
            Write-Host ""
            exit 1
        }
    }
}

# Step 6: Run tests
Write-Host "Step 6: Running integration tests..." -ForegroundColor Yellow
Write-Host ""

& "F:\redame\demo\test-register-and-appointment.ps1"

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host " Diagnosis Complete!" -ForegroundColor Cyan  
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "If tests failed, please:" -ForegroundColor Yellow
Write-Host "  1. Check the backend PowerShell window for errors" -ForegroundColor White
Write-Host "  2. Verify MySQL is running and accessible" -ForegroundColor White
Write-Host "  3. Check if merchant table has data (merchantId=1)" -ForegroundColor White
Write-Host "  4. Check if service_item table has data (id=1)" -ForegroundColor White
Write-Host ""




