# 打开图片保存文件夹
Write-Host "📂 打开摩托车图片保存文件夹" -ForegroundColor Cyan
Write-Host ""

$imagePath = "F:\redame\vue-project\public\images\motorcycles"

Write-Host "📍 目标路径：" -ForegroundColor Yellow
Write-Host "   $imagePath" -ForegroundColor White
Write-Host ""

# 检查目录是否存在
if (Test-Path $imagePath) {
    Write-Host "✅ 文件夹存在" -ForegroundColor Green
    
    # 检查是否有图片
    $jpgFiles = Get-ChildItem -Path $imagePath -Filter "*.jpg" -ErrorAction SilentlyContinue
    $pngFiles = Get-ChildItem -Path $imagePath -Filter "*.png" -ErrorAction SilentlyContinue
    $count = ($jpgFiles | Measure-Object).Count + ($pngFiles | Measure-Object).Count
    
    Write-Host ""
    if ($count -gt 0) {
        Write-Host "📷 当前已有 $count 张图片：" -ForegroundColor Green
        foreach ($file in ($jpgFiles + $pngFiles)) {
            $size = [math]::Round($file.Length / 1KB, 2)
            Write-Host "   ✓ $($file.Name) ($size KB)" -ForegroundColor Gray
        }
    } else {
        Write-Host "⚠️  文件夹中暂无图片" -ForegroundColor Yellow
        Write-Host ""
        Write-Host "请按照以下步骤保存图片：" -ForegroundColor Cyan
        Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor DarkGray
        Write-Host ""
        Write-Host "1️⃣  找到您的摩托车图片" -ForegroundColor White
        Write-Host "   （从浏览器、下载文件夹等）" -ForegroundColor Gray
        Write-Host ""
        Write-Host "2️⃣  复制或移动到此文件夹" -ForegroundColor White
        Write-Host ""
        Write-Host "3️⃣  重命名为以下名称：" -ForegroundColor White
        Write-Host "   moto-1.jpg  (第一张)" -ForegroundColor Gray
        Write-Host "   moto-2.jpg  (第二张)" -ForegroundColor Gray
        Write-Host "   moto-3.jpg  (第三张)" -ForegroundColor Gray
        Write-Host "   moto-4.jpg  (第四张)" -ForegroundColor Gray
        Write-Host "   moto-5.jpg  (第五张)" -ForegroundColor Gray
        Write-Host "   moto-6.jpg  (第六张)" -ForegroundColor Gray
        Write-Host ""
        Write-Host "4️⃣  刷新浏览器 (F5)" -ForegroundColor White
        Write-Host ""
        Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor DarkGray
    }
} else {
    Write-Host "❌ 文件夹不存在，正在创建..." -ForegroundColor Red
    New-Item -ItemType Directory -Force -Path $imagePath | Out-Null
    Write-Host "✅ 文件夹已创建" -ForegroundColor Green
}

Write-Host ""
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor DarkGray
Write-Host ""
Write-Host "🚀 正在打开文件夹..." -ForegroundColor Cyan
Write-Host ""

# 打开文件夹
Start-Process explorer $imagePath

Write-Host "✅ 文件夹已在新窗口中打开" -ForegroundColor Green
Write-Host ""
Write-Host "💡 提示：" -ForegroundColor Magenta
Write-Host "   请将您的摩托车图片保存到此文件夹中" -ForegroundColor Gray
Write-Host "   并重命名为 moto-1.jpg 到 moto-6.jpg" -ForegroundColor Gray
Write-Host ""
Write-Host "📖 查看详细说明：" -ForegroundColor Cyan
Write-Host "   F:\redame\demo\📝图片保存指南.md" -ForegroundColor White
Write-Host "   F:\redame\demo\🚨图片未保存-快速修复.md" -ForegroundColor White
Write-Host ""

# 等待用户按键
Write-Host "按任意键继续..." -ForegroundColor Gray
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")





