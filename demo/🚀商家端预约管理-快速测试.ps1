# 商家端预约管理 - 快速测试脚本
# 自动化测试商家端预约管理功能

Write-Host @"
╔═══════════════════════════════════════════════════════════╗
║                                                           ║
║     🎯 商家端预约管理 - 快速测试                        ║
║                                                           ║
║     测试商家端查看和管理用户预约功能                    ║
║                                                           ║
╚═══════════════════════════════════════════════════════════╝
"@ -ForegroundColor Cyan

# 1. 确认服务状态
Write-Host "`n【第1步】检查服务状态..." -ForegroundColor Yellow

# 检查后端 (8080)
Write-Host "`n检查后端服务 (8080端口)..." -ForegroundColor Gray
try {
    $response = Invoke-WebRequest -Uri "http://localhost:8080/health" -Method Get -TimeoutSec 3 -ErrorAction Stop
    Write-Host "  ✅ 后端服务运行正常" -ForegroundColor Green
} catch {
    try {
        $response = Invoke-WebRequest -Uri "http://localhost:8080" -Method Get -TimeoutSec 3 -ErrorAction Stop
        Write-Host "  ✅ 后端服务运行正常 (未配置health端点)" -ForegroundColor Green
    } catch {
        Write-Host "  ❌ 后端服务未运行！请先在IDEA中启动后端" -ForegroundColor Red
        Write-Host "     请在 IDEA 中运行 DemoApplication.java" -ForegroundColor Yellow
        exit 1
    }
}

# 检查前端 (5173 - 商家端)
Write-Host "`n检查商家端前端 (5173端口)..." -ForegroundColor Gray
try {
    $response = Invoke-WebRequest -Uri "http://localhost:5173" -Method Get -TimeoutSec 3 -ErrorAction Stop
    Write-Host "  ✅ 商家端前端运行正常" -ForegroundColor Green
} catch {
    Write-Host "  ❌ 商家端前端未运行！" -ForegroundColor Red
    Write-Host "     请运行: cd F:\redame\vue-project && npm run dev" -ForegroundColor Yellow
    exit 1
}

# 检查用户端前端 (5175)
Write-Host "`n检查用户端前端 (5175端口)..." -ForegroundColor Gray
try {
    $response = Invoke-WebRequest -Uri "http://localhost:5175" -Method Get -TimeoutSec 3 -ErrorAction Stop
    Write-Host "  ✅ 用户端前端运行正常" -ForegroundColor Green
} catch {
    Write-Host "  ⚠️ 用户端前端未运行（可选）" -ForegroundColor Yellow
    Write-Host "     如需测试完整流程，请运行另一个前端实例在5175端口" -ForegroundColor Gray
}

Start-Sleep -Seconds 1

# 2. 测试步骤指南
Write-Host "`n`n【第2步】测试指南" -ForegroundColor Yellow
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor DarkGray

Write-Host "`n📝 完整测试流程：" -ForegroundColor Cyan

Write-Host "`n  A. 用户端 - 创建预约" -ForegroundColor Green
Write-Host "     1. 打开: http://localhost:5175" -ForegroundColor Gray
Write-Host "     2. 登录普通用户（如果尚未登录）" -ForegroundColor Gray
Write-Host "     3. 选择商家（DDL测试维修店）" -ForegroundColor Gray
Write-Host "     4. 点击'预约'按钮" -ForegroundColor Gray
Write-Host "     5. 填写预约信息：" -ForegroundColor Gray
Write-Host "        - 服务：常规保养套餐" -ForegroundColor DarkGray
Write-Host "        - 时间：明天 10:00" -ForegroundColor DarkGray
Write-Host "        - 车型：雅马哈 YZF-R1" -ForegroundColor DarkGray
Write-Host "        - 车牌：京A12345" -ForegroundColor DarkGray
Write-Host "        - 电话：138****1234" -ForegroundColor DarkGray
Write-Host "        - 描述：定期保养检查" -ForegroundColor DarkGray
Write-Host "     6. 提交预约" -ForegroundColor Gray

Write-Host "`n  B. 商家端 - 查看并管理预约" -ForegroundColor Green
Write-Host "     1. 打开: http://localhost:5173/shop/login" -ForegroundColor Gray
Write-Host "     2. 登录商家账号：" -ForegroundColor Gray
Write-Host "        - 用户名: DDL123" -ForegroundColor DarkGray
Write-Host "        - 密码: （您设置的密码）" -ForegroundColor DarkGray
Write-Host "     3. 进入商家首页：http://localhost:5173/shop/home" -ForegroundColor Gray
Write-Host "     4. 🎯 点击左侧'预约管理'菜单（第2项，📅日历图标）" -ForegroundColor Cyan
Write-Host "        ↓" -ForegroundColor Yellow
Write-Host "     5. ✨ 查看预约列表（应该能看到刚才创建的预约）" -ForegroundColor Cyan
Write-Host "     6. 点击'确认'按钮，确认预约" -ForegroundColor Gray
Write-Host "     7. 点击'开始服务'，标记服务开始" -ForegroundColor Gray
Write-Host "     8. 点击'完成'，标记服务完成" -ForegroundColor Gray

# 3. 测试商家登录
Write-Host "`n`n【第3步】测试商家登录API" -ForegroundColor Yellow
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor DarkGray

$merchantUsername = Read-Host "`n请输入商家用户名（默认: DDL123）"
if ([string]::IsNullOrWhiteSpace($merchantUsername)) {
    $merchantUsername = "DDL123"
}

$merchantPassword = Read-Host "请输入商家密码（默认: 123456）" -AsSecureString
$merchantPasswordPlain = [Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($merchantPassword))
if ([string]::IsNullOrWhiteSpace($merchantPasswordPlain)) {
    $merchantPasswordPlain = "123456"
}

Write-Host "`n测试商家登录..." -ForegroundColor Gray

$loginUrl = "http://localhost:8080/api/user/login"
$loginBody = @{
    username = $merchantUsername
    password = $merchantPasswordPlain
} | ConvertTo-Json

try {
    $loginResponse = Invoke-RestMethod -Uri $loginUrl -Method Post -Body $loginBody -ContentType "application/json; charset=utf-8"
    
    if ($loginResponse.code -eq 200) {
        Write-Host "  ✅ 商家登录成功！" -ForegroundColor Green
        Write-Host "     Token: $($loginResponse.data.token.Substring(0, 20))..." -ForegroundColor Gray
        Write-Host "     用户类型: $($loginResponse.data.userType)" -ForegroundColor Gray
        
        # 保存token
        $token = $loginResponse.data.token
        
        # 4. 测试获取商家预约列表
        Write-Host "`n`n【第4步】测试获取商家预约列表" -ForegroundColor Yellow
        Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor DarkGray
        
        $appointmentsUrl = "http://localhost:8080/api/appointment/merchant/list"
        $headers = @{
            "Authorization" = "Bearer $token"
            "Content-Type" = "application/json; charset=utf-8"
        }
        
        Write-Host "`n正在获取预约列表..." -ForegroundColor Gray
        
        try {
            $appointmentsResponse = Invoke-RestMethod -Uri $appointmentsUrl -Method Get -Headers $headers
            
            if ($appointmentsResponse.code -eq 200) {
                $appointments = $appointmentsResponse.data.records
                $totalCount = $appointmentsResponse.data.total
                
                Write-Host "  ✅ 成功获取预约列表！" -ForegroundColor Green
                Write-Host "     总预约数: $totalCount" -ForegroundColor Gray
                
                if ($appointments.Count -gt 0) {
                    Write-Host "`n  📋 预约列表：" -ForegroundColor Cyan
                    
                    foreach ($apt in $appointments) {
                        Write-Host "`n  ┌─────────────────────────────────────────────" -ForegroundColor DarkGray
                        Write-Host "  │ 📋 预约单号: $($apt.orderNo)" -ForegroundColor White
                        Write-Host "  │ 👤 用户: $($apt.userName)" -ForegroundColor Gray
                        Write-Host "  │ 📞 电话: $($apt.contactPhone)" -ForegroundColor Gray
                        Write-Host "  │ 🏍️  车辆: $($apt.motorcycleBrand) $($apt.motorcycleModel) ($($apt.licensePlate))" -ForegroundColor Gray
                        Write-Host "  │ 🛠️  服务: $($apt.serviceItemName)" -ForegroundColor Gray
                        Write-Host "  │ 🕐 时间: $($apt.appointmentTime)" -ForegroundColor Gray
                        Write-Host "  │ 📝 描述: $($apt.description)" -ForegroundColor Gray
                        
                        # 状态显示
                        $statusText = switch ($apt.status) {
                            0 { "⏰ 待确认"; $color = "Yellow" }
                            1 { "✔️  已确认"; $color = "Blue" }
                            2 { "🔄 进行中"; $color = "Cyan" }
                            3 { "✅ 已完成"; $color = "Green" }
                            4 { "❌ 已取消"; $color = "Red" }
                            default { "❓ 未知"; $color = "Gray" }
                        }
                        Write-Host "  │ 状态: $statusText" -ForegroundColor $color
                        Write-Host "  └─────────────────────────────────────────────" -ForegroundColor DarkGray
                    }
                    
                    Write-Host "`n  🎉 商家端预约管理功能测试成功！" -ForegroundColor Green
                    Write-Host "     现在您可以在浏览器中：" -ForegroundColor Gray
                    Write-Host "     1. 打开: http://localhost:5173/shop/home" -ForegroundColor Cyan
                    Write-Host "     2. 点击左侧'预约管理'菜单" -ForegroundColor Cyan
                    Write-Host "     3. 查看和管理这些预约" -ForegroundColor Cyan
                    
                } else {
                    Write-Host "`n  ⚠️  暂无预约记录" -ForegroundColor Yellow
                    Write-Host "     请先在用户端创建预约：" -ForegroundColor Gray
                    Write-Host "     1. 打开: http://localhost:5175" -ForegroundColor Cyan
                    Write-Host "     2. 登录用户账号" -ForegroundColor Cyan
                    Write-Host "     3. 选择商家并创建预约" -ForegroundColor Cyan
                }
                
            } else {
                Write-Host "  ❌ 获取预约列表失败：$($appointmentsResponse.msg)" -ForegroundColor Red
            }
        } catch {
            Write-Host "  ❌ API请求失败：$($_.Exception.Message)" -ForegroundColor Red
            Write-Host "     响应内容：$($_.ErrorDetails.Message)" -ForegroundColor Yellow
        }
        
    } else {
        Write-Host "  ❌ 商家登录失败：$($loginResponse.msg)" -ForegroundColor Red
        Write-Host "     请检查：" -ForegroundColor Yellow
        Write-Host "     1. 用户名密码是否正确" -ForegroundColor Gray
        Write-Host "     2. 该账号是否为商家账号（user_type=2）" -ForegroundColor Gray
        Write-Host "     3. merchant表中是否有对应记录" -ForegroundColor Gray
    }
    
} catch {
    Write-Host "  ❌ 登录请求失败：$($_.Exception.Message)" -ForegroundColor Red
    if ($_.ErrorDetails.Message) {
        Write-Host "     响应内容：$($_.ErrorDetails.Message)" -ForegroundColor Yellow
    }
}

# 5. 打开浏览器
Write-Host "`n`n【第5步】打开浏览器测试" -ForegroundColor Yellow
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor DarkGray

Write-Host "`n是否自动打开浏览器？ (Y/n)" -ForegroundColor Cyan
$openBrowser = Read-Host
if ($openBrowser -ne 'n' -and $openBrowser -ne 'N') {
    Write-Host "`n正在打开浏览器..." -ForegroundColor Gray
    
    # 打开商家登录页
    Start-Process "http://localhost:5173/shop/login"
    
    Start-Sleep -Seconds 2
    
    Write-Host "  ✅ 已打开商家登录页" -ForegroundColor Green
    Write-Host "     请登录后点击'预约管理'菜单" -ForegroundColor Gray
}

# 总结
Write-Host "`n`n╔═══════════════════════════════════════════════════════════╗" -ForegroundColor Cyan
Write-Host "║                                                           ║" -ForegroundColor Cyan
Write-Host "║     ✅ 测试完成！                                        ║" -ForegroundColor Cyan
Write-Host "║                                                           ║" -ForegroundColor Cyan
Write-Host "║     📝 下一步：                                          ║" -ForegroundColor Cyan
Write-Host "║     1. 在浏览器中登录商家账号                            ║" -ForegroundColor Cyan
Write-Host "║     2. 点击左侧'预约管理'菜单（📅图标）                ║" -ForegroundColor Cyan
Write-Host "║     3. 查看和管理用户预约                                ║" -ForegroundColor Cyan
Write-Host "║                                                           ║" -ForegroundColor Cyan
Write-Host "╚═══════════════════════════════════════════════════════════╝" -ForegroundColor Cyan

Write-Host "`n按任意键退出..." -ForegroundColor Gray
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")


