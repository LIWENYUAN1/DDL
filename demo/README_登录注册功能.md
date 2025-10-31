# 摩托车服务平台 - 登录注册功能说明

## 功能概述

已完成前端的登录和注册功能，并与后端API成功对接。

## 已实现的功能

### 1. 用户注册
- ✅ 用户名唯一性检查
- ✅ 手机号格式验证
- ✅ 密码强度提示
- ✅ 验证码验证（前端图形验证码）
- ✅ 两次密码一致性验证
- ✅ 用户协议确认
- ✅ 支持用户和商家两种注册类型
- ✅ 注册成功后自动跳转登录页

### 2. 用户登录
- ✅ 支持三种角色登录：普通用户、商家、管理员
- ✅ 用户名和密码验证
- ✅ 角色类型匹配验证
- ✅ 记住密码功能
- ✅ 登录失败显示验证码
- ✅ 错误信息友好提示
- ✅ JWT Token 生成和存储
- ✅ 登录成功后跳转首页

### 3. 表单验证
- ✅ 实时表单验证
- ✅ 密码强度检测（弱/中/强）
- ✅ 友好的错误提示
- ✅ 防止重复提交

### 4. 用户体验优化
- ✅ 美观的渐变背景
- ✅ 动画效果
- ✅ 响应式设计（支持移动端）
- ✅ Loading状态提示
- ✅ 成功/失败消息提示

## 技术实现

### 前端技术栈
- **框架**: Vue 3 + TypeScript
- **UI组件**: Element Plus
- **状态管理**: Pinia
- **路由**: Vue Router 4
- **HTTP客户端**: Axios

### 后端技术栈
- **框架**: Spring Boot 3.x
- **ORM**: MyBatis Plus
- **安全**: Spring Security
- **认证**: JWT (JSON Web Token)
- **密码加密**: BCrypt
- **数据库**: MySQL 8.0

## 文件结构

### 前端主要文件
```
vue-project/
├── src/
│   ├── api/
│   │   └── index.ts                    # API接口定义
│   ├── components/
│   │   └── common/
│   │       ├── LoginForm.vue           # 登录表单组件
│   │       └── RegisterForm.vue        # 注册表单组件
│   ├── views/
│   │   ├── LoginView.vue               # 登录页面
│   │   └── RegisterView.vue            # 注册页面
│   ├── utils/
│   │   └── axios.ts                    # Axios配置和拦截器
│   ├── store/
│   │   └── modules/
│   │       └── user.ts                 # 用户状态管理
│   └── router/
│       └── index.ts                    # 路由配置
```

### 后端主要文件
```
demo/
├── src/main/java/com/example/demo/
│   ├── controller/
│   │   └── AuthController.java         # 认证控制器
│   ├── service/
│   │   ├── SysUserService.java         # 用户服务接口
│   │   └── impl/
│   │       └── SysUserServiceImpl.java # 用户服务实现
│   ├── dto/
│   │   ├── LoginRequestDTO.java        # 登录请求DTO
│   │   ├── RegisterRequestDTO.java     # 注册请求DTO
│   │   └── UserDTO.java                # 用户信息DTO
│   ├── entity/
│   │   └── SysUser.java                # 用户实体
│   ├── mapper/
│   │   └── SysUserMapper.java          # 用户数据访问层
│   ├── config/
│   │   ├── SecurityConfig.java         # Spring Security配置
│   │   ├── JwtConfig.java              # JWT配置
│   │   └── CorsConfig.java             # 跨域配置
│   └── exception/
│       ├── BusinessException.java      # 业务异常
│       └── GlobalExceptionHandler.java # 全局异常处理器
└── src/main/resources/
    ├── application.properties          # 应用配置
    └── motorcycle_service_platform.sql # 数据库脚本
```

## API接口

### 1. 注册接口
```
POST /auth/register

请求体:
{
  "username": "testuser",
  "password": "Test123!",
  "confirmPassword": "Test123!",
  "phone": "13800138000",
  "userType": 1,  // 1-普通用户, 2-商家
  "code": "验证码"
}

响应:
{
  "code": 200,
  "message": "操作成功",
  "data": true
}
```

### 2. 登录接口
```
POST /auth/login

请求体:
{
  "username": "testuser",
  "password": "Test123!",
  "userType": 1  // 1-车主, 2-商家, 3-管理员
}

响应:
{
  "code": 200,
  "message": "操作成功",
  "data": {
    "id": 1,
    "username": "testuser",
    "phone": "13800138000",
    "userType": 1,
    "token": "eyJhbGciOiJIUzI1NiJ9..."
  }
}
```

## 数据库表结构

### sys_user 表
```sql
CREATE TABLE `sys_user` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '用户ID（主键）',
  `username` varchar(50) NOT NULL COMMENT '用户名（唯一）',
  `password` varchar(100) NOT NULL COMMENT '加密后的密码（BCrypt算法）',
  `phone` varchar(20) NOT NULL COMMENT '手机号（唯一）',
  `email` varchar(100) DEFAULT NULL COMMENT '邮箱（可选）',
  `real_name` varchar(50) DEFAULT NULL COMMENT '真实姓名',
  `user_type` tinyint NOT NULL COMMENT '用户类型：1-车主，2-商家管理员，3-平台管理员',
  `status` tinyint NOT NULL DEFAULT '1' COMMENT '状态：0-禁用，1-正常',
  `avatar` varchar(255) DEFAULT NULL COMMENT '头像URL',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_username` (`username`),
  UNIQUE KEY `uk_phone` (`phone`),
  KEY `idx_user_type` (`user_type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='系统用户表';
```

## 使用说明

### 启动步骤

1. **启动数据库**
```bash
# 确保MySQL服务运行
# 创建数据库并导入SQL脚本
mysql -u root -p motorcycle_service_platform < demo/src/main/resources/motorcycle_service_platform.sql
```

2. **启动后端**
```bash
cd demo
mvnw.cmd spring-boot:run  # Windows
./mvnw spring-boot:run     # Linux/Mac
```

3. **启动前端**
```bash
cd vue-project
npm install  # 首次运行需要安装依赖
npm run dev
```

4. **访问应用**
- 前端地址: http://localhost:5173
- 后端API: http://localhost:8080

### 测试账号

注册新账号测试，或使用以下方式：

**管理员账号**（如果数据库中已存在）:
- 用户名: admin
- 密码: 查看数据库中的加密密码

**普通用户**:
- 需要先注册

**商家用户**:
- 需要先注册（选择商家入驻）

## 功能截图说明

### 登录页面
- 支持切换三种角色登录
- 记住密码功能
- 忘记密码功能
- 失败后显示验证码

### 注册页面
- 支持用户/商家注册切换
- 实时用户名检查
- 密码强度提示
- 表单验证提示
- 用户协议确认

## 后续开发计划

1. **短信验证码**: 集成阿里云或腾讯云短信服务
2. **邮箱验证**: 添加邮箱注册和验证功能
3. **第三方登录**: 微信、QQ等第三方登录
4. **找回密码**: 通过手机或邮箱找回密码
5. **实名认证**: 添加身份证验证功能
6. **头像上传**: 支持用户上传头像
7. **个人资料**: 完善用户资料页面
8. **登录日志**: 记录用户登录历史

## 安全措施

1. ✅ 密码BCrypt加密存储
2. ✅ JWT Token认证
3. ✅ SQL注入防护（MyBatis Plus）
4. ✅ XSS防护（Element Plus自动转义）
5. ✅ CORS跨域配置
6. ✅ 登录失败显示验证码
7. ⏳ 登录限流（待实现）
8. ⏳ 密码复杂度强制要求（待实现）
9. ⏳ 防暴力破解（待实现）

## 注意事项

1. **数据库密码**: 请修改 `application.properties` 中的数据库密码为你的实际密码
2. **JWT密钥**: 生产环境请修改 `jwt.secret` 为更复杂的密钥
3. **端口冲突**: 如果8080或5173端口被占用，请修改配置
4. **CORS**: 生产环境需要限制允许的域名
5. **验证码**: 当前使用前端图形验证码，建议后续改为后端验证

## 常见问题

### Q1: 登录后跳转到空白页？
A: 因为用户角色首页还未开发，可以修改路由配置暂时跳转到其他页面。

### Q2: 注册时提示用户名已存在？
A: 检查数据库是否已有相同用户名，或清空测试数据。

### Q3: 密码加密后无法登录？
A: 确保前后端都使用BCrypt加密，检查密码是否正确。

### Q4: Token验证失败？
A: 检查JWT配置，确保前后端的secret一致。

### Q5: 跨域问题？
A: 检查后端的CORS配置，确保允许前端域名。

## 技术支持

如有问题，请查看：
1. 后端日志: `demo/logs/` 或控制台输出
2. 前端控制台: 浏览器开发者工具 -> Console
3. 网络请求: 浏览器开发者工具 -> Network
4. 详细测试指南: `测试指南.md`

---

**版本**: v1.0  
**更新日期**: 2025-10-21  
**开发者**: AI Assistant


