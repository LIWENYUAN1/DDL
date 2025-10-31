# 🚀 Navicat快速操作 - 只需3步

## 第1步：打开查询窗口

1. 打开Navicat
2. 连接MySQL数据库
3. 在左侧找到 `motorcycle_service_platform` 数据库
4. **右键点击数据库名** → 选择 **"新建查询"**

![](https://via.placeholder.com/600x100/4CAF50/FFFFFF?text=右键数据库+→+新建查询)

---

## 第2步：复制并执行SQL

### 复制这段SQL到查询窗口：

```sql
USE motorcycle_service_platform;

-- 创建测试商家
INSERT INTO merchant (merchant_name, user_id, contact_name, contact_phone, address, latitude, longitude, location, business_hours, merchant_type, status)
VALUES ('DDL测试维修店', 5, '李师傅', '13008620788', '北京市朝阳区建国路99号', 39.904200, 116.407396, ST_GeomFromText('POINT(116.407396 39.904200)'), '08:00-21:00', 1, 1);

SET @m = LAST_INSERT_ID();

-- 插入服务项目
INSERT INTO service_item (merchant_id, category_id, item_name, price, status)
VALUES 
(@m, 6, '常规保养套餐', 200.00, 1),
(@m, 8, '刹车系统维护', 300.00, 1),
(1, 6, '机油更换服务', 180.00, 1),
(1, 8, '刹车保养', 280.00, 1);

-- 查看结果
SELECT * FROM merchant;
SELECT * FROM service_item;
```

### 点击"运行"按钮
- 工具栏绿色三角形 ▶️
- 或按 `F5` 键
- 或按 `Ctrl+R`

---

## 第3步：验证数据

### 在结果窗口查看：
- ✅ merchant表：应该有2条记录
- ✅ service_item表：应该有4条记录

### 或者直接查看表：
1. 在左侧找到 `merchant` 表
2. **双击**打开
3. 应该看到2个商家

---

## ✅ 成功标志

如果看到：
- merchant表有 `DDL测试维修店`
- service_item表有4条服务记录
- 没有红色错误提示

**恭喜！数据插入成功！**

---

## 🔴 如果遇到错误

### 错误1：Duplicate entry（重复数据）

**解决**：先删除旧数据
```sql
DELETE FROM service_item WHERE merchant_id > 1;
DELETE FROM merchant WHERE id > 1;
```
然后重新执行插入SQL。

### 错误2：Cannot add foreign key（外键错误）

**解决**：临时禁用外键检查
在SQL最前面加上：
```sql
SET FOREIGN_KEY_CHECKS=0;
```
在SQL最后面加上：
```sql
SET FOREIGN_KEY_CHECKS=1;
```

---

## 📱 需要帮助？

把错误信息截图或复制给我，我会帮您解决！

---

**现在就打开Navicat开始操作吧！** 🎯




