-- ============================================
-- 插入测试数据脚本
-- ============================================

USE motorcycle_service_platform;

-- 1. 插入测试商家数据
INSERT INTO merchant (id, merchant_name, contact_person, contact_phone, address, business_license, status, create_time, update_time)
VALUES 
(1, '阳光摩托车维修店', '张师傅', '13800138001', '北京市朝阳区建国路88号', 'BL2024001', 1, NOW(), NOW()),
(2, '速度与激情车行', '李经理', '13800138002', '上海市浦东新区世纪大道123号', 'BL2024002', 1, NOW(), NOW()),
(3, '专业摩托维护中心', '王技师', '13800138003', '广州市天河区中山大道456号', 'BL2024003', 1, NOW(), NOW())
ON DUPLICATE KEY UPDATE 
    merchant_name=VALUES(merchant_name),
    update_time=NOW();

-- 2. 插入服务项目数据
INSERT INTO service_item (id, item_name, description, price, status, create_time, update_time)
VALUES 
(1, '常规保养', '更换机油、机滤、空滤，检查刹车系统', 200.00, 1, NOW(), NOW()),
(2, '刹车维护', '检查更换刹车片、刹车盘和刹车油', 300.00, 1, NOW(), NOW()),
(3, '轮胎更换', '更换前后轮胎，包含动平衡', 500.00, 1, NOW(), NOW()),
(4, '链条保养', '清洁、润滑、调整传动链', 100.00, 1, NOW(), NOW()),
(5, '电气系统检修', '检查电瓶、线路、灯光系统', 150.00, 1, NOW(), NOW()),
(6, '发动机大修', '拆解检修发动机，更换磨损件', 2000.00, 1, NOW(), NOW()),
(7, '减震器维护', '检查更换前后减震油封', 400.00, 1, NOW(), NOW()),
(8, '全车深度清洗', '专业清洗护理，打蜡抛光', 80.00, 1, NOW(), NOW())
ON DUPLICATE KEY UPDATE 
    item_name=VALUES(item_name),
    description=VALUES(description),
    price=VALUES(price),
    update_time=NOW();

-- 3. 验证数据插入
SELECT '=== 商家数据 ===' as info;
SELECT id, merchant_name, contact_person, contact_phone, status FROM merchant;

SELECT '=== 服务项目数据 ===' as info;
SELECT id, item_name, description, price, status FROM service_item;

SELECT '=== 用户数据 ===' as info;
SELECT id, username, phone, user_type, status FROM sys_user ORDER BY id DESC LIMIT 5;

-- 显示统计信息
SELECT 
    '数据统计' as info,
    (SELECT COUNT(*) FROM merchant) as merchant_count,
    (SELECT COUNT(*) FROM service_item) as service_item_count,
    (SELECT COUNT(*) FROM sys_user) as user_count,
    (SELECT COUNT(*) FROM appointment) as appointment_count;




