# Quick test for login and register

Write-Host "================================" -ForegroundColor Cyan
Write-Host " Login and Register Quick Test" -ForegroundColor Cyan  
Write-Host "================================" -ForegroundColor Cyan
Write-Host ""

Write-Host "Frontend URL: http://localhost:5175" -ForegroundColor Green
Write-Host "Backend  URL: http://localhost:8080" -ForegroundColor Green
Write-Host ""

Write-Host "Test Accounts Available:" -ForegroundColor Yellow
Write-Host "  Username: testuser529" -ForegroundColor White
Write-Host "  Password: 123456" -ForegroundColor White
Write-Host ""
Write-Host "  Username: testuser850" -ForegroundColor White
Write-Host "  Password: 123456" -ForegroundColor White
Write-Host ""

Write-Host "Press any key to run automated test..." -ForegroundColor Yellow
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")

& ".\test-login-fix.ps1"





