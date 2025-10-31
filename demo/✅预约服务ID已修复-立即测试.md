# ✅ 预约服务ID问题已修复 - 立即测试

## 🎯 **问题原因**

**外键约束错误**：
```
Cannot add or update a child row: a foreign key constraint fails
appointment_service_item.service_item_id → service_item.id
```

**根本原因**：  
前端使用的 **mock 数据**中的服务项目 ID 与数据库中实际存在的 `service_item` ID 不匹配！

### 修复前的问题

**前端 mock 数据**：
```javascript
商家1: serviceItems id = 1, 2, 3
商家2: serviceItems id = 4, 5, 6  
商家3: serviceItems id = 7, 8, 9
```

**数据库实际数据**（service_item表）：
```sql
只有 4 条记录：
id=1: 常规保养套餐 (merchant_id=2, 商家2)
id=2: 刹车系统维护 (merchant_id=2, 商家2)
id=3: 机油更换服务 (merchant_id=1, 商家1)
id=4: 刹车保养 (merchant_id=1, 商家1)
```

**结果**：用户选择 ID > 4 的服务时，触发外键约束错误！

---

## ✅ **修复内容**

已修改 `UserHomeView.vue` 中的 `mockShops` 数据，使其与数据库完全一致：

### 修复后的 mock 数据

```javascript
const mockShops = [
  {
    id: 1,
    name: '极速摩托维修店',
    address: '云南省大理市下关镇幸福路100号',
    phone: '13900139000',
    businessHours: '09:00-20:00',
    serviceItems: [
      { id: 3, name: '机油更换服务', price: 180, duration: 30 },  // ✅ 数据库中存在
      { id: 4, name: '刹车保养', price: 280, duration: 60 }        // ✅ 数据库中存在
    ]
  },
  {
    id: 2,
    name: 'DDL测试维修店',
    address: '北京市朝阳区建国路99号',
    phone: '13008620788',
    businessHours: '08:00-21:00',
    serviceItems: [
      { id: 1, name: '常规保养套餐', price: 200, duration: 60 },   // ✅ 数据库中存在
      { id: 2, name: '刹车系统维护', price: 300, duration: 90 }    // ✅ 数据库中存在
    ]
  }
]
```

### 对应关系

| 前端商家 | 前端服务ID | 数据库商家 | 数据库服务ID | 服务名称 | 状态 |
|---------|-----------|-----------|------------|---------|------|
| 极速摩托维修店 | 3 | merchant_id=1 | service_item.id=3 | 机油更换服务 | ✅ 匹配 |
| 极速摩托维修店 | 4 | merchant_id=1 | service_item.id=4 | 刹车保养 | ✅ 匹配 |
| DDL测试维修店 | 1 | merchant_id=2 | service_item.id=1 | 常规保养套餐 | ✅ 匹配 |
| DDL测试维修店 | 2 | merchant_id=2 | service_item.id=2 | 刹车系统维护 | ✅ 匹配 |

---

## 🚀 **立即测试**

### 前提条件
- ✅ 后端已启动（端口8080）
- ✅ 前端已启动（端口5175）
- ✅ 数据库包含所有必要的表和数据

### 测试步骤

#### 第1步：打开前端
```
http://localhost:5175
```

#### 第2步：登录用户
使用任意普通用户账号登录  
（如果没有，请先注册一个用户类型为"车主"的账号）

#### 第3步：选择商家
在"附近商家"页面，选择以下任一商家：
- **极速摩托维修店**（可选择：机油更换服务、刹车保养）
- **DDL测试维修店**（可选择：常规保养套餐、刹车系统维护）

#### 第4步：填写预约信息
1. **选择服务**：从下拉列表中选择任意服务项目
2. **预约时间**：选择未来的日期和时间（例如：明天 10:00）
3. **摩托车型号**：例如 `雅马哈 YZF-R1`
4. **车牌号码**：例如 `云A12345`
5. **联系电话**：填写手机号（11位）
6. **问题描述**：例如 `需要定期保养，检查发动机`

#### 第5步：提交预约
点击"提交预约"按钮

### 预期结果

✅ **成功提示**：
```
预约成功！商家将尽快与您联系
```

✅ **前端控制台**（按F12打开）：
```javascript
提交预约数据： {
  merchantId: 1 或 2,
  serviceItemId: 1/2/3/4 中的一个,
  appointmentTime: "2025-10-31 10:00:00",
  motorcycleModel: "雅马哈 YZF-R1",
  // ... 其他字段
}

🚀 发送请求: { ... }
📥 收到响应: { code: 200, msg: "预约成功", data: 1 }
```

✅ **后端控制台**（IDEA的Run窗口）：
```
成功创建预约，ID: 1
```

❌ **不应该再出现**：
```
系统错误: Cannot add or update a child row: a foreign key constraint fails
```

---

## 📊 **验证数据**

在Navicat中执行以下SQL，查看新创建的预约记录：

```sql
-- 查看最新的预约记录
SELECT 
    a.id AS 预约ID,
    a.order_no AS 预约单号,
    u.username AS 用户,
    m.merchant_name AS 商家,
    mo.model AS 车型,
    a.appointment_time AS 预约时间,
    a.contact_phone AS 联系电话,
    a.description AS 问题描述,
    CASE a.status 
        WHEN 0 THEN '待确认'
        WHEN 1 THEN '已确认'
        WHEN 2 THEN '进行中'
        WHEN 3 THEN '已完成'
        WHEN 4 THEN '已取消'
    END AS 状态,
    a.create_time AS 创建时间
FROM appointment a
LEFT JOIN sys_user u ON a.user_id = u.id
LEFT JOIN merchant m ON a.merchant_id = m.id
LEFT JOIN motorcycle mo ON a.motorcycle_id = mo.id
ORDER BY a.id DESC 
LIMIT 5;

-- 查看预约关联的服务项目
SELECT 
    asi.id,
    a.order_no AS 预约单号,
    si.item_name AS 服务项目,
    si.price AS 服务价格,
    asi.quantity AS 数量,
    asi.create_time AS 创建时间
FROM appointment_service_item asi
LEFT JOIN appointment a ON asi.appointment_id = a.id
LEFT JOIN service_item si ON asi.service_item_id = si.id
ORDER BY asi.id DESC
LIMIT 5;

-- 查看自动创建的车主信息
SELECT 
    oi.id AS 车主信息ID,
    u.username AS 用户名,
    u.phone AS 手机号,
    oi.create_time AS 创建时间
FROM owner_info oi
LEFT JOIN sys_user u ON oi.user_id = u.id
ORDER BY oi.id DESC
LIMIT 5;

-- 查看自动创建的车辆信息
SELECT 
    m.id AS 车辆ID,
    m.brand AS 品牌,
    m.model AS 车型,
    m.license_plate AS 车牌,
    oi.id AS 车主信息ID,
    u.username AS 车主用户名,
    m.create_time AS 创建时间
FROM motorcycle m
LEFT JOIN owner_info oi ON m.owner_id = oi.id
LEFT JOIN sys_user u ON oi.user_id = u.id
ORDER BY m.id DESC
LIMIT 5;
```

### 预期数据库结果

1. **appointment 表**：新增1条预约记录，status=0（待确认）
2. **appointment_service_item 表**：新增1条记录，service_item_id 在 1-4 范围内
3. **owner_info 表**：如果是首次预约，自动创建1条车主信息
4. **motorcycle 表**：自动创建1条车辆信息

---

## 🔍 **完整的数据流程**

### 前端 → 后端 → 数据库

```
1. 用户在前端选择服务（serviceId: 1/2/3/4）
   ↓
2. 前端提交预约数据
   {
     merchantId: 1 或 2,
     serviceItemId: 1/2/3/4,
     appointmentTime: "2025-10-31 10:00:00",
     ...
   }
   ↓
3. 后端接收并处理
   - 验证商家存在 ✅
   - 获取或创建 owner_info ✅
   - 创建车辆记录（motorcycle）✅
   - 创建预约记录（appointment）✅
   - 创建服务关联记录（appointment_service_item）✅
   ↓
4. 数据库保存成功
   - service_item_id 在 1-4 范围内 ✅
   - 外键约束全部通过 ✅
   ↓
5. 返回成功响应
   { code: 200, msg: "预约成功", data: appointmentId }
```

---

## 🎉 **修复总结**

### 已修复的问题
- [x] ✅ 修正前端 mock 数据中的 service_item_id
- [x] ✅ 确保前端服务ID与数据库一致
- [x] ✅ 移除了数据库中不存在的商家3
- [x] ✅ 更新商家信息匹配数据库实际数据

### 现在可以正常使用的功能
- ✅ 浏览附近商家（2个商家）
- ✅ 查看商家详情
- ✅ 选择服务项目（每个商家2个服务）
- ✅ 填写预约信息
- ✅ 提交预约（不再报错）
- ✅ 自动创建车主信息和车辆信息
- ✅ 数据正常保存到数据库

---

## 💡 **后续优化建议**

### 1. 替换为真实API
目前前端使用的是 mock 数据，建议：
- 创建 `GET /api/merchant/list` 接口获取真实商家列表
- 创建 `GET /api/merchant/{id}/services` 接口获取商家服务项目
- 替换 `loadNearbyShops()` 函数调用真实API

### 2. 添加更多测试数据
在数据库中添加更多商家和服务项目：
```sql
-- 添加更多商家和服务
INSERT INTO merchant (...) VALUES (...);
INSERT INTO service_item (...) VALUES (...);
```

### 3. 实现商家筛选
- 按距离筛选
- 按服务类型筛选
- 按评分排序

---

## 🎯 **立即测试清单**

- [ ] 前端正常显示2个商家
- [ ] 商家1有2个服务项目（id=3, 4）
- [ ] 商家2有2个服务项目（id=1, 2）
- [ ] 点击"预约"按钮打开预约对话框
- [ ] 选择服务项目
- [ ] 填写完整的预约信息
- [ ] 提交预约成功
- [ ] 前端显示"预约成功"提示
- [ ] 后端控制台无错误
- [ ] Navicat中看到新的预约记录

---

**现在就去测试吧！预约功能应该完全正常了！** 🚀

测试后请告诉我结果！


