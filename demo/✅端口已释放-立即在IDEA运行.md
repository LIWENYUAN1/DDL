# ✅ 端口8080已释放 - 现在可以在IDEA中运行了！

## 🎉 问题已解决

✅ 已成功杀掉占用8080端口的进程（PID: 131432）  
✅ 端口8080现在已空闲  
✅ 可以在IntelliJ IDEA中启动项目了

---

## 🚀 在IDEA中启动后端 - 3步操作

### 第1步：在IDEA中找到启动类

1. 在IDEA左侧项目树中，找到：
   ```
   src/main/java/com/example/demo/DemoApplication.java
   ```

2. 右键点击 `DemoApplication.java`

3. 选择 **"Run 'DemoApplication.main()'"**  
   或按快捷键 `Shift+F10`

---

### 第2步：等待启动

在IDEA底部的 **Run** 窗口中，您会看到：

```
  .   ____          _            __ _ _
 /\\ / ___'_ __ _ _(_)_ __  __ _ \ \ \ \
( ( )\___ | '_ | '_| | '_ \/ _` | \ \ \ \
 \\/  ___)| |_)| | | | | || (_| |  ) ) ) )
  '  |____| .__|_| |_|_| |_\__, | / / / /
 =========|_|==============|___/=/_/_/_/
 :: Spring Boot ::                (v3.2.5)

...
Tomcat started on port 8080 (http) with context path ''
Started DemoApplication in 3.xxx seconds
```

**看到这个就说明启动成功了！** ✅

---

### 第3步：验证服务运行

打开浏览器访问：
```
http://localhost:8080/actuator/health
```

应该显示：
```json
{"status":"UP"}
```

---

## 📋 后续步骤

### 1. 在Navicat中插入测试数据

打开Navicat，执行以下SQL：

```sql
USE motorcycle_service_platform;

-- 清理旧数据
DELETE FROM service_item WHERE merchant_id > 1;
DELETE FROM merchant WHERE id > 1;

-- 创建测试商家
INSERT INTO merchant (merchant_name, user_id, contact_name, contact_phone, address, latitude, longitude, location, business_hours, merchant_type, status)
VALUES ('DDL测试维修店', 5, '李师傅', '13008620788', '北京市朝阳区建国路99号', 39.904200, 116.407396, ST_GeomFromText('POINT(116.407396 39.904200)'), '08:00-21:00', 1, 1);

SET @m = LAST_INSERT_ID();

-- 插入服务项目
INSERT INTO service_item (merchant_id, category_id, item_name, price, duration, description, status)
VALUES 
(@m, 6, '常规保养套餐', 200.00, 60, '包含更换机油、机滤、空滤', 1),
(@m, 8, '刹车系统维护', 300.00, 90, '检查更换刹车片刹车油', 1),
(1, 6, '机油更换服务', 180.00, 30, '使用优质机油', 1),
(1, 8, '刹车保养', 280.00, 60, '全面检查刹车系统', 1);

-- 验证数据
SELECT * FROM merchant;
SELECT * FROM service_item;
```

### 2. 启动前端

打开新的PowerShell窗口：
```powershell
cd F:\redame\vue-project
npm run dev
```

### 3. 测试完整功能

浏览器访问：`http://localhost:5175`

测试流程：
1. 注册账号（选择"普通用户"）
2. 登录
3. 点击"我要预约"
4. 选择商家和服务
5. 提交预约

---

## 🔧 如果再次遇到端口占用

### 方法1：使用PowerShell快速脚本

保存并运行以下脚本：
```powershell
# 杀掉8080端口进程
$port = 8080
$process = Get-NetTCPConnection -LocalPort $port -ErrorAction SilentlyContinue | Select-Object -ExpandProperty OwningProcess
if ($process) {
    Write-Host "杀掉进程 $process..." -ForegroundColor Yellow
    Stop-Process -Id $process -Force
    Write-Host "✅ 端口 $port 已释放" -ForegroundColor Green
} else {
    Write-Host "✅ 端口 $port 未被占用" -ForegroundColor Green
}
```

### 方法2：手动命令

```powershell
# 查找进程
netstat -ano | findstr :8080

# 杀掉进程（替换PID）
taskkill /PID <进程ID> /F
```

### 方法3：在IDEA中停止

点击IDEA顶部工具栏的红色 **停止** 按钮 ⬛  
或按快捷键 `Ctrl+F2`

---

## 💡 IDEA使用技巧

### 快捷键
- `Shift+F10` - 运行当前配置
- `Ctrl+F2` - 停止当前运行
- `Shift+F9` - Debug模式运行
- `Ctrl+F5` - 重新运行

### 查看日志
- 底部 **Run** 窗口 - 查看控制台输出
- 底部 **Services** 窗口 - 查看服务状态

### 常用操作
- **Build** → **Rebuild Project** - 重新构建
- **File** → **Invalidate Caches / Restart** - 清理缓存（如果遇到奇怪问题）

---

## 🎯 现在就去IDEA中启动吧！

1. 找到 `DemoApplication.java`
2. 右键 → Run
3. 等待启动成功
4. 访问 http://localhost:8080/actuator/health 验证

**祝启动成功！** 🚀

有任何问题随时告诉我！




