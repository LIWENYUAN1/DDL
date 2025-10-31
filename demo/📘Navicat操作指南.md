# 📘 Navicat操作指南 - 插入测试数据

## 🎯 在Navicat中执行SQL的步骤

### 方法1：使用查询窗口（推荐）⭐

#### 第1步：打开查询窗口
1. 打开Navicat
2. 连接到您的MySQL数据库
3. 在左侧找到 `motorcycle_service_platform` 数据库
4. **右键点击** 数据库名称
5. 选择 **"新建查询"** 或 **"查询"** → **"新建查询"**

#### 第2步：复制SQL代码
复制以下SQL代码到查询窗口：

```sql
USE motorcycle_service_platform;

-- 创建测试商家（使用DDL123用户）
INSERT INTO merchant (
    merchant_name, user_id, contact_name, contact_phone, address, 
    latitude, longitude, location, business_hours, merchant_type, status
) VALUES (
    'DDL测试维修店', 5, '李师傅', '13008620788', '北京市朝阳区建国路99号',
    39.904200, 116.407396, ST_GeomFromText('POINT(116.407396 39.904200)'),
    '08:00-21:00', 1, 1
);

-- 获取刚插入的商家ID
SET @test_merchant_id = LAST_INSERT_ID();

-- 为新商家插入服务项目
INSERT INTO service_item (merchant_id, category_id, item_name, price, duration, description, status)
VALUES 
(@test_merchant_id, 6, '常规保养套餐', 200.00, 60, '包含更换机油、机滤、空滤', 1),
(@test_merchant_id, 8, '刹车系统维护', 300.00, 90, '检查更换刹车片刹车油', 1);

-- 为原有商家(id=1)也插入服务项目
INSERT INTO service_item (merchant_id, category_id, item_name, price, duration, description, status)
VALUES 
(1, 6, '机油更换服务', 180.00, 30, '使用优质机油', 1),
(1, 8, '刹车保养', 280.00, 60, '全面检查刹车系统', 1);

-- 验证数据
SELECT '商家信息：' as info;
SELECT id, merchant_name, user_id, contact_name, status FROM merchant;

SELECT '服务项目：' as info;
SELECT si.id, m.merchant_name, si.item_name, si.price 
FROM service_item si 
JOIN merchant m ON si.merchant_id = m.id;
```

#### 第3步：执行SQL
1. 点击工具栏的 **"运行"** 按钮（绿色三角形▶️）
   - 或按快捷键 `F5` 或 `Ctrl+R`
2. 等待执行完成

#### 第4步：查看结果
在下方的 **"结果"** 或 **"消息"** 标签中查看：
- ✅ 应该看到插入成功的消息
- ✅ 显示商家和服务项目数据
- ✅ 没有错误提示

---

### 方法2：直接在表中查看（验证）

#### 查看merchant表
1. 在左侧展开 `motorcycle_service_platform` 数据库
2. 找到 `merchant` 表
3. **双击**打开表
4. 应该看到2条记录：
   - id=1: 极速摩托维修店
   - 新插入的: DDL测试维修店

#### 查看service_item表
1. 找到 `service_item` 表
2. **双击**打开表
3. 应该看到4条记录（2个商家各2个服务项目）

---

### 方法3：使用SQL文件（可选）

#### 第1步：保存SQL文件
1. 确保 `完美匹配您数据库的SQL.sql` 文件存在
2. 位置：`F:\redame\demo\完美匹配您数据库的SQL.sql`

#### 第2步：在Navicat中打开
1. 点击Navicat菜单栏的 **"文件"** → **"打开SQL文件..."**
2. 浏览到 `F:\redame\demo\`
3. 选择 `完美匹配您数据库的SQL.sql`
4. 点击 **"打开"**

#### 第3步：执行
1. SQL会在新的查询窗口中打开
2. 点击 **"运行"** 按钮（▶️）
3. 查看结果

---

## 🔍 常见问题解决

### 问题1：执行时提示错误

**检查连接**：
- 确保Navicat已连接到MySQL
- 左侧数据库名称前有绿色图标表示已连接

**检查数据库**：
- 确保选择了正确的数据库 `motorcycle_service_platform`
- SQL第一行 `USE motorcycle_service_platform;` 会自动切换

### 问题2：提示外键错误

**临时禁用外键检查**：
在SQL最前面添加：
```sql
SET FOREIGN_KEY_CHECKS=0;
-- 您的SQL代码
SET FOREIGN_KEY_CHECKS=1;
```

### 问题3：提示重复数据

**清理旧数据**：
先执行清理SQL：
```sql
-- 删除旧的测试数据
DELETE FROM service_item WHERE merchant_id IN (
    SELECT id FROM merchant WHERE merchant_name LIKE '%测试%'
);
DELETE FROM merchant WHERE merchant_name LIKE '%测试%';
```

然后再执行插入SQL。

---

## 📊 验证数据的快捷方法

### 在Navicat中快速查询

**方法1：使用查询窗口**
```sql
-- 查看所有商家
SELECT * FROM merchant;

-- 查看所有服务项目（带商家名）
SELECT 
    si.id,
    m.merchant_name,
    si.item_name,
    si.price,
    sc.category_name
FROM service_item si
JOIN merchant m ON si.merchant_id = m.id
JOIN service_category sc ON si.category_id = sc.id;

-- 统计数据
SELECT 
    (SELECT COUNT(*) FROM merchant) as 商家数量,
    (SELECT COUNT(*) FROM service_item) as 服务项目数量;
```

**方法2：直接查看表**
1. 双击表名
2. 查看数据
3. 可以直接编辑、删除数据

---

## 🎯 执行成功的标志

执行SQL后，您应该看到：

### 在查询结果中
- ✅ merchant表有2条记录
- ✅ service_item表有4条记录
- ✅ 显示验证查询的结果

### 在数据表中
- ✅ `merchant` 表：2个商家
  - 极速摩托维修店（id=1）
  - DDL测试维修店（新插入）
- ✅ `service_item` 表：4个服务项目
  - 每个商家2个服务

---

## 🚀 执行SQL后的下一步

### 1. 启动后端
打开PowerShell：
```powershell
cd F:\redame\demo
.\mvnw.cmd spring-boot:run
```

### 2. 测试功能
新开PowerShell窗口：
```powershell
cd F:\redame\demo
.\test-register-and-appointment.ps1
```

### 3. 访问前端
浏览器打开：`http://localhost:5175`

---

## 💡 Navicat技巧

### 快捷键
- `F5` 或 `Ctrl+R`：运行SQL
- `Ctrl+/`：注释/取消注释
- `Ctrl+Shift+F`：格式化SQL
- `F6`：运行选中的SQL

### 多语句执行
- Navicat默认支持执行多条SQL语句
- 用分号 `;` 分隔即可
- 可以一次性执行整个SQL文件

### 查看执行历史
1. 点击 **"查询"** → **"SQL历史记录"**
2. 可以查看之前执行过的SQL
3. 双击可以重新执行

---

**现在就打开Navicat，按照上面的步骤执行SQL吧！** 🎯

如果遇到任何错误，把错误截图或复制错误信息告诉我！




