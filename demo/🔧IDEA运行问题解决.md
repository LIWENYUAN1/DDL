# 🔧 IntelliJ IDEA 运行问题解决指南

## 🔍 第1步：查看完整错误日志

### 在IDEA中查看完整错误
1. 在IDEA底部找到 **"Run"** 标签页
2. 滚动到最上面，查看完整的错误堆栈
3. 找到 `Caused by:` 开头的行，这是根本原因

### 常见错误信息：
- `Port 8080 was already in use` - 端口被占用
- `Bean definition conflicts` - Bean冲突
- `Failed to configure a DataSource` - 数据库连接失败
- `ClassNotFoundException` - 缺少依赖

---

## 🚀 快速解决方案

### 方案1：停止所有运行的服务

#### 在IDEA中停止
1. 点击IDEA顶部工具栏的红色 **停止** 按钮 ⬛
2. 或按快捷键 `Ctrl+F2`

#### 检查8080端口
打开PowerShell执行：
```powershell
# 查看8080端口占用
netstat -ano | findstr :8080
```

如果有进程占用：
```powershell
# 杀掉进程（替换<PID>为实际的进程ID）
taskkill /PID <PID> /F
```

---

### 方案2：在IDEA中启用Debug模式查看详细错误

#### 步骤：
1. 在IDEA中打开 `application.properties`
2. 添加以下配置：
```properties
# 启用debug模式
debug=true
logging.level.root=DEBUG
```

3. 重新运行项目
4. 查看详细的错误日志

---

### 方案3：清理并重新构建

#### 在IDEA中操作：
1. 点击菜单 **Build** → **Clean Project**
2. 等待清理完成
3. 点击 **Build** → **Rebuild Project**
4. 重新运行

#### 或使用Maven清理：
在IDEA右侧Maven工具栏：
1. 展开 **Lifecycle**
2. 双击 **clean**
3. 双击 **compile**
4. 重新运行

---

### 方案4：检查数据库连接

确保 `application.properties` 配置正确：
```properties
spring.datasource.url=jdbc:mysql://localhost:3306/motorcycle_service_platform?useUnicode=true&characterEncoding=UTF-8&serverTimezone=Asia/Shanghai
spring.datasource.username=root
spring.datasource.password=123456
```

**重要**：确认数据库密码是否正确！

---

### 方案5：使用PowerShell运行（推荐）

如果IDEA一直有问题，可以用PowerShell运行：

#### 停止IDEA中的运行
1. 点击停止按钮 ⬛
2. 关闭IDEA的Run窗口

#### 打开PowerShell
```powershell
# 进入项目目录
cd F:\redame\demo

# 清理编译
.\mvnw.cmd clean compile

# 启动服务
.\mvnw.cmd spring-boot:run
```

---

## 📋 请按以下步骤操作

### 第1步：发送完整错误日志

请在IDEA的Run窗口中：
1. 滚动到最顶部
2. 找到所有 **红色** 的错误信息
3. 复制 **完整的错误堆栈**（特别是 `Caused by:` 部分）
4. 发送给我

### 第2步：检查端口占用

在PowerShell中执行：
```powershell
netstat -ano | findstr :8080
```

如果有输出，说明端口被占用，执行：
```powershell
# 查看占用端口的进程详情
Get-Process -Id <PID>

# 如果是之前的Java进程，杀掉它
taskkill /PID <PID> /F
```

### 第3步：验证数据库连接

在Navicat中：
1. 尝试连接数据库
2. 确认能正常连接
3. 确认数据库名称是 `motorcycle_service_platform`

---

## 🎯 最可能的原因和解决方法

### 原因1：端口8080被占用 ⭐⭐⭐⭐⭐
**症状**：提示 `Port 8080 was already in use`

**解决**：
```powershell
# 找到占用进程
netstat -ano | findstr :8080
# 杀掉进程
taskkill /PID <进程ID> /F
```

### 原因2：数据库密码错误 ⭐⭐⭐⭐
**症状**：提示 `Access denied for user 'root'`

**解决**：
检查 `application.properties` 中的密码：
```properties
spring.datasource.password=123456
```
确认与您的MySQL密码一致！

### 原因3：Redis未启动但没有禁用 ⭐⭐⭐
**症状**：提示 `Could not connect to Redis`

**解决**：
在 `application.properties` 中确认：
```properties
spring.autoconfigure.exclude=org.springframework.boot.autoconfigure.data.redis.RedisAutoConfiguration
```

### 原因4：Lombok未生效 ⭐⭐
**症状**：提示找不到getter/setter方法

**解决**：
1. IDEA中安装Lombok插件
2. File → Settings → Build, Execution, Deployment → Compiler → Annotation Processors
3. 勾选 **Enable annotation processing**

---

## 💡 IDEA中运行的正确配置

### 检查运行配置
1. 点击IDEA顶部的运行配置下拉框
2. 选择 **Edit Configurations...**
3. 检查：
   - **Main class**: `com.example.demo.DemoApplication`
   - **Working directory**: `F:\redame\demo`
   - **Use classpath of module**: `demo`

### JDK配置
确保使用Java 17：
1. File → Project Structure → Project
2. **SDK**: 选择 Java 17
3. **Language level**: 17

---

## 🆘 如果还是不行

### 临时方案：使用PowerShell运行

```powershell
# 1. 停止IDEA中的所有运行
# 2. 打开PowerShell

cd F:\redame\demo

# 清理并启动
.\mvnw.cmd clean spring-boot:run
```

这样至少能看到完整的错误日志，并且更容易调试。

---

## 📨 需要我帮助的信息

请提供以下信息：

1. **完整的错误堆栈**（IDEA Run窗口中的红色文字，从头到尾）
2. **端口检查结果**：
   ```powershell
   netstat -ano | findstr :8080
   ```
3. **MySQL密码**：确认 `application.properties` 中的密码是否正确
4. **IDEA版本**：您已说是 2025.2.1

把这些信息发给我，我会精确定位问题！🎯




