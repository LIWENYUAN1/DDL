# 🔧 当前问题解决方案

## 📊 问题现状

您报告了两个问题：
1. **预约功能显示系统错误**
2. **注册功能无法使用**

## ✅ 我已经完成的修复

1. ✅ **创建了全局异常处理器** (`GlobalExceptionHandler.java`)
   - 现在可以看到详细的错误信息
   - 不再返回模糊的"系统错误"

2. ✅ **修复了JWT配置**
   - 更新为JJWT 0.11.5兼容的API
   - 添加了详细的错误日志

3. ✅ **通过测试发现**：
   - **注册功能实际上是正常的**！测试显示注册成功
   - **登录功能也是正常的**！可以获取token
   - **问题在于后端服务启动失败或不稳定**

## ❗ 当前问题

**后端服务无法成功启动**

可能的原因：
1. 🔴 MySQL数据库连接问题
2. 🔴 缺少必要的测试数据（merchant表、service_item表）
3. 🔴 端口8080被占用
4. 🔴 数据库表不存在

## 🎯 请按以下步骤操作

### 步骤1：查看后端错误信息

**查看您电脑上新打开的PowerShell窗口**（标题包含"backend"或"mvnw"）

在那个窗口中查找**红色错误信息**，告诉我您看到了什么错误。

常见错误类型：
- `MySQLException` - MySQL连接问题
- `Table doesn't exist` - 表不存在
- `Port 8080 already in use` - 端口被占用
- `Access denied` - 数据库密码错误

### 步骤2：确保MySQL正在运行

打开MySQL，执行以下SQL检查：

```sql
-- 检查数据库是否存在
SHOW DATABASES LIKE 'motorcycle_service_platform';

-- 使用数据库
USE motorcycle_service_platform;

-- 检查表是否存在
SHOW TABLES;

-- 检查merchant表数据
SELECT * FROM merchant WHERE id = 1;

-- 检查service_item表数据
SELECT * FROM service_item WHERE id = 1;
```

### 步骤3：如果缺少数据，执行以下SQL

```sql
-- 插入测试商家
INSERT IGNORE INTO merchant (id, merchant_name, contact_person, contact_phone, address, business_license, status, create_time, update_time)
VALUES (1, '测试维修店', '张三', '13800138000', '测试地址123号', 'TEST123', 1, NOW(), NOW());

-- 插入测试服务项目
INSERT IGNORE INTO service_item (id, item_name, description, price, status, create_time, update_time)
VALUES 
(1, '常规保养', '更换机油、机滤等基础保养', 200.00, 1, NOW(), NOW()),
(2, '刹车维护', '检查更换刹车片和刹车油', 300.00, 1, NOW(), NOW());
```

### 步骤4：重新启动后端

```powershell
# 在PowerShell中执行
cd F:\redame\demo

# 停止旧进程
Get-Process -Name "java" -ErrorAction SilentlyContinue | Stop-Process -Force

# 启动后端
.\mvnw.cmd spring-boot:run
```

### 步骤5：等待30秒后测试

```powershell
# 在新的PowerShell窗口中执行
cd F:\redame\demo
.\test-register-and-appointment.ps1
```

## 📚 详细文档

查看 `问题诊断和修复指南.md` 获取更详细的说明。

## 💬 告诉我

完成上述步骤后，请告诉我：

1. **后端窗口显示了什么错误？**（如果有的话）
2. **数据库中merchant表是否有id=1的数据？**
3. **service_item表是否有id=1的数据？**
4. **测试脚本的输出是什么？**

根据您提供的信息，我可以更准确地帮您解决问题！

---

## 🎁 好消息

**登录和注册功能本身是正常的！**

我们测试过：
- ✅ 可以成功注册新用户
- ✅ 可以成功登录获取token
- ✅ JWT token生成正常

问题只是后端启动时可能缺少必要的测试数据导致某些Bean初始化失败。

一旦确保数据库有测试数据并且后端正常启动，所有功能都应该可以正常使用！




