# 查看首页轮播图效果
Write-Host "🏍️ 启动摩托车平台 - 查看轮播图效果" -ForegroundColor Cyan
Write-Host ""
Write-Host "✨ 轮播图特性：" -ForegroundColor Yellow
Write-Host "   🎨 精美的图片轮播展示" -ForegroundColor White
Write-Host "   ⏰ 自动播放（每 4 秒切换）" -ForegroundColor White
Write-Host "   🖱️ 左右箭头手动切换" -ForegroundColor White
Write-Host "   📍 底部指示器快速跳转" -ForegroundColor White
Write-Host "   💫 图片缓慢放大动画" -ForegroundColor White
Write-Host "   ✨ 信息卡片淡入效果" -ForegroundColor White
Write-Host "   📱 完整响应式设计" -ForegroundColor White
Write-Host ""
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor DarkGray
Write-Host ""

# 检查图片目录
$imagePath = "F:\redame\vue-project\public\images\motorcycles"
Write-Host "📂 检查图片目录..." -ForegroundColor Green

if (Test-Path $imagePath) {
    $images = Get-ChildItem -Path $imagePath -Filter "*.jpg" -ErrorAction SilentlyContinue
    $count = ($images | Measure-Object).Count
    
    if ($count -gt 0) {
        Write-Host "   ✅ 找到 $count 张图片" -ForegroundColor Green
        Write-Host ""
        foreach ($img in $images) {
            Write-Host "   📷 $($img.Name)" -ForegroundColor Gray
        }
    } else {
        Write-Host "   ⚠️  未找到图片文件" -ForegroundColor Yellow
        Write-Host ""
        Write-Host "请按照说明将图片保存到：" -ForegroundColor Yellow
        Write-Host "   $imagePath" -ForegroundColor White
        Write-Host ""
        Write-Host "图片命名：" -ForegroundColor Yellow
        Write-Host "   moto-1.jpg, moto-2.jpg, moto-3.jpg," -ForegroundColor White
        Write-Host "   moto-4.jpg, moto-5.jpg, moto-6.jpg" -ForegroundColor White
    }
} else {
    Write-Host "   ❌ 图片目录不存在" -ForegroundColor Red
    Write-Host "   正在创建目录..." -ForegroundColor Yellow
    New-Item -ItemType Directory -Force -Path $imagePath | Out-Null
    Write-Host "   ✅ 目录已创建：$imagePath" -ForegroundColor Green
}

Write-Host ""
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor DarkGray
Write-Host ""

# 启动前端
Write-Host "📂 切换到前端目录..." -ForegroundColor Green
cd F:\redame\vue-project

Write-Host "🚀 启动前端开发服务器..." -ForegroundColor Green
Write-Host ""
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor DarkGray
Write-Host ""
Write-Host "🌐 访问地址：http://localhost:5173/" -ForegroundColor Cyan
Write-Host ""
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor DarkGray
Write-Host ""
Write-Host "💡 操作提示：" -ForegroundColor Magenta
Write-Host "   • 页面加载后即可看到轮播图" -ForegroundColor Gray
Write-Host "   • 点击左右箭头切换图片" -ForegroundColor Gray
Write-Host "   • 点击底部指示器快速跳转" -ForegroundColor Gray
Write-Host "   • 点击右上角按钮暂停/播放" -ForegroundColor Gray
Write-Host "   • 观察图片缓慢放大动画" -ForegroundColor Gray
Write-Host "   • 查看信息卡片从左侧滑入" -ForegroundColor Gray
Write-Host ""
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor DarkGray
Write-Host ""

npm run dev





