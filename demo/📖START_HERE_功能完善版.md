# 📖 摩托车服务平台 - 快速上手指南（功能完善版）

## 🎉 欢迎使用摩托车服务平台

本平台已实现**完整的用户预约、商家管理、管理员监控**三端交互功能！

---

## ⚡ 5分钟快速开始

### 第一步：启动服务

#### 1. 启动后端（必须）
```powershell
# 方式1：使用脚本
cd F:\redame\demo
.\mvnw.cmd spring-boot:run

# 方式2：如果已经在运行，可以跳过
```

**等待看到**：`Started DemoApplication in X seconds`

#### 2. 启动前端（必须）
```powershell
# 新开一个终端
cd F:\redame\vue-project
npm run dev
```

**等待看到**：`Local: http://localhost:5173/`

### 第二步：打开浏览器
访问：http://localhost:5173

### 第三步：开始测试
**双击运行测试脚本**：`🎊功能完善完成-立即测试.ps1`

---

## 🧪 测试流程

### 场景1：用户预约服务（最核心功能）

#### 步骤1：用户登录
```
1. 访问 http://localhost:5173
2. 点击"登录"按钮
3. 输入：
   用户名：testuser456
   密码：Test123456
4. 登录成功，跳转到用户首页
```

#### 步骤2：查看商家
```
在用户首页，点击侧边栏"附近商家"
可以看到已审核通过的商家列表
```

#### 步骤3：创建预约（后端API已就绪）
```
目前可以通过API直接创建预约：

POST http://localhost:8080/api/appointment/create
Headers:
  Authorization: Bearer {登录后获取的token}
Body:
{
  "merchantId": 1,
  "motorcycleId": 1,
  "appointmentTime": "2025-10-23T10:00:00",
  "appointmentType": 2,
  "serviceType": 1,
  "serviceAddress": "测试地址",
  "remark": "测试预约",
  "serviceItems": []
}
```

#### 步骤4：查看预约
```
用户首页 → 侧边栏 → "我的预约"
可以看到刚才创建的预约（状态：待确认）
```

### 场景2：商家处理预约

#### 步骤1：商家登录
```
1. 退出当前账号
2. 访问：http://localhost:5173/#/shop/login
3. 需要先注册商家账号（如果还没有）
   - 点击"注册"
   - 填写商家信息
   - 提交后等待管理员审核
```

#### 步骤2：查看预约列表
```
商家首页 → 侧边栏 → "预约管理"
可以看到用户创建的预约
```

#### 步骤3：处理预约（通过API）
```
# 确认预约
POST http://localhost:8080/api/merchant/appointments/{appointmentId}/confirm
Headers: Authorization: Bearer {商家token}

# 完成预约
POST http://localhost:8080/api/merchant/appointments/{appointmentId}/complete
Headers: Authorization: Bearer {商家token}

# 拒绝预约
POST http://localhost:8080/api/merchant/appointments/{appointmentId}/reject?reason=抱歉，当天已满
Headers: Authorization: Bearer {商家token}
```

### 场景3：管理员审核和监控

#### 步骤1：管理员登录
```
1. 访问：http://localhost:5173/#/admin/login
2. 输入：
   用户名：admin123
   密码：Admin123456
3. 登录成功，跳转到管理员首页
```

#### 步骤2：查看平台数据
```
管理员首页会显示：
- 用户总数
- 商家总数
- 预约总数
- 待审核商家数
- 今日预约数
```

#### 步骤3：审核商家（通过API）
```
# 查看待审核商家
GET http://localhost:8080/api/admin/merchants?status=0
Headers: Authorization: Bearer {管理员token}

# 审核通过
POST http://localhost:8080/api/admin/merchants/{merchantId}/approve
Headers: Authorization: Bearer {管理员token}

# 审核拒绝
POST http://localhost:8080/api/admin/merchants/{merchantId}/reject?reason=资料不全
Headers: Authorization: Bearer {管理员token}
```

#### 步骤4：查看所有预约
```
GET http://localhost:8080/api/admin/appointments?pageNum=1&pageSize=10
Headers: Authorization: Bearer {管理员token}
```

---

## 🔑 测试账号

| 角色 | 用户名 | 密码 | 登录页面 |
|------|--------|------|----------|
| 👤 普通用户 | testuser456 | Test123456 | /login |
| 👨‍💼 管理员 | admin123 | Admin123456 | /admin/login |
| 🏪 商家 | 需要注册 | - | /shop/login |

---

## 📝 API接口清单（可直接使用）

### 用户端API
```
POST   /api/appointment/create          - 创建预约
GET    /api/appointment/user/list       - 我的预约列表
POST   /api/appointment/cancel/{id}     - 取消预约
GET    /api/appointment/detail/{id}     - 预约详情
```

### 商家端API
```
GET    /api/merchant/info                          - 商家信息
PUT    /api/merchant/info                          - 更新商家信息
GET    /api/merchant/appointments                  - 预约列表
POST   /api/merchant/appointments/{id}/confirm     - 确认预约
POST   /api/merchant/appointments/{id}/complete    - 完成预约
POST   /api/merchant/appointments/{id}/reject      - 拒绝预约
GET    /api/merchant/statistics                    - 营业统计
```

### 管理员API
```
GET    /api/admin/users                    - 用户列表
PUT    /api/admin/users/{id}/status        - 修改用户状态
GET    /api/admin/merchants                - 商家列表
POST   /api/admin/merchants/{id}/approve   - 审核通过
POST   /api/admin/merchants/{id}/reject    - 审核拒绝
GET    /api/admin/appointments             - 所有预约
GET    /api/admin/statistics               - 平台统计
```

### 公共API（无需登录）
```
GET    /api/public/merchants/nearby        - 附近商家
GET    /api/public/merchants/{id}          - 商家详情
GET    /api/public/merchants               - 所有商家
```

---

## 📂 前端API调用示例

### 引入API文件
```typescript
import { createAppointment, getUserAppointments } from '@/api/appointment'
import { getMerchantAppointments, confirmAppointment } from '@/api/merchant'
import { getStatistics, getMerchants } from '@/api/admin'
```

### 调用示例
```typescript
// 创建预约
const res = await createAppointment({
  merchantId: 1,
  motorcycleId: 1,
  appointmentTime: '2025-10-23T10:00:00',
  appointmentType: 2,
  serviceType: 1,
  serviceAddress: '测试地址',
  remark: '测试预约',
  serviceItems: []
})

// 获取预约列表
const list = await getUserAppointments({ pageNum: 1, pageSize: 10 })

// 确认预约（商家）
await confirmAppointment(appointmentId)

// 获取统计（管理员）
const stats = await getStatistics()
```

---

## 🎯 完整业务流程

```
用户注册登录
    ↓
查看附近商家
    ↓
创建预约 → [数据库：appointment表，status=0]
    ↓
商家登录
    ↓
查看预约列表
    ↓
确认预约 → [数据库：status=1]
    ↓
提供服务
    ↓
完成预约 → [数据库：status=2]
    ↓
管理员监控
    ↓
查看所有预约数据
查看平台统计
审核新商家
```

---

## 📖 详细文档

1. **功能完善完成指南** - `✅功能完善完成指南.md`
   - 所有API接口说明
   - 前端页面实现示例
   - 测试清单

2. **完整功能实现总结** - `🎉完整功能实现总结.md`
   - 项目概览
   - 技术栈
   - 项目结构
   - 业务流程

3. **功能完善计划** - `🎯功能完善计划.md`
   - 系统架构
   - 数据流程
   - 实施步骤

---

## 🛠️ 使用Postman测试API

### 1. 导入环境变量
创建环境变量：
- `baseURL`: http://localhost:8080
- `token`: （登录后获取）

### 2. 登录获取Token
```
POST {{baseURL}}/auth/login
Body:
{
  "username": "testuser456",
  "password": "Test123456",
  "userType": 1
}

响应中获取token，设置到环境变量
```

### 3. 测试预约API
```
POST {{baseURL}}/api/appointment/create
Headers:
  Authorization: Bearer {{token}}
Body:
{
  "merchantId": 1,
  "motorcycleId": 1,
  "appointmentTime": "2025-10-23T10:00:00",
  "appointmentType": 2,
  "serviceType": 1,
  "serviceAddress": "测试地址",
  "remark": "测试预约",
  "serviceItems": []
}
```

---

## ✅ 检查清单

### 后端检查
- [ ] 后端服务已启动（http://localhost:8080）
- [ ] 数据库已连接（motorcycle_service_platform）
- [ ] 可以访问 /actuator/health

### 前端检查
- [ ] 前端服务已启动（http://localhost:5173）
- [ ] 首页可以正常显示
- [ ] 可以访问登录页面

### 功能检查
- [ ] 用户可以登录
- [ ] 管理员可以登录
- [ ] 可以创建预约（通过API）
- [ ] 可以查看预约列表
- [ ] 商家可以确认预约（通过API）
- [ ] 管理员可以查看统计

---

## 🎨 首页特色

访问 http://localhost:5173 可以看到：

- ✅ 精美的紫色渐变设计
- ✅ 平台介绍和数据统计
- ✅ 6种摩托车类型展示
  - 街车、跑车、巡航车
  - 越野车、复古车、踏板车
- ✅ 动态SVG图标和悬停效果
- ✅ 服务特色展示
- ✅ 完整的页脚信息

---

## 🚀 下一步

### 前端UI完善（可选）
虽然后端功能已完整，但可以继续完善前端UI：

1. **用户预约页面** - 图形化创建预约界面
2. **商家管理页面** - 可视化预约管理
3. **管理员控制台** - 数据图表展示

### 功能增强（可选）
1. 支付功能
2. 评价系统
3. 消息通知
4. 车辆管理

---

## 💡 遇到问题？

### 后端无法启动
```powershell
# 清理并重新编译
cd F:\redame\demo
.\mvnw.cmd clean compile
.\mvnw.cmd spring-boot:run
```

### 前端无法启动
```powershell
# 重新安装依赖
cd F:\redame\vue-project
npm install
npm run dev
```

### 无法登录
1. 检查后端是否正常运行
2. 检查浏览器控制台是否有错误
3. 确认账号密码正确

---

## 📞 技术支持

查看详细文档：
- `✅功能完善完成指南.md`
- `🎉完整功能实现总结.md`

---

**🎉 开始使用吧！所有核心功能已准备就绪！**

**立即测试**：双击运行 `🎊功能完善完成-立即测试.ps1`





