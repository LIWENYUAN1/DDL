-- ============================================
-- 最简单的测试数据 - 直接执行即可
-- ============================================

USE motorcycle_service_platform;

-- 第1步：插入商家用户（如果已存在会跳过）
INSERT INTO sys_user (username, password, phone, user_type, status, create_time, update_time)
SELECT 'merchant_test', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z2EE4lb8Qrx7hQo3DqsFy2/u', '13900000001', 2, 1, NOW(), NOW()
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM sys_user WHERE username = 'merchant_test');

-- 第2步：插入商家数据（使用已存在的user_id=1，或者根据实际情况修改）
-- 方案A：如果sys_user表已经有数据，使用现有用户ID
INSERT INTO merchant (
    merchant_name, user_id, contact_name, contact_phone, address, 
    latitude, longitude, location, business_hours, merchant_type, status
)
SELECT 
    '测试摩托维修店',
    (SELECT MIN(id) FROM sys_user WHERE user_type = 2 LIMIT 1),  -- 使用第一个商家用户
    '张师傅',
    '13900139000',
    '北京市朝阳区建国路88号',
    39.904200,
    116.407396,
    ST_GeomFromText('POINT(116.407396 39.904200)'),
    '09:00-20:00',
    1,
    1
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM merchant WHERE merchant_name = '测试摩托维修店');

-- 第3步：插入服务项目
INSERT INTO service_item (item_name, description, price, status, create_time, update_time)
SELECT '常规保养', '更换机油、机滤、空滤，检查刹车系统', 200.00, 1, NOW(), NOW()
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM service_item WHERE item_name = '常规保养');

INSERT INTO service_item (item_name, description, price, status, create_time, update_time)
SELECT '刹车维护', '检查更换刹车片、刹车盘和刹车油', 300.00, 1, NOW(), NOW()
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM service_item WHERE item_name = '刹车维护');

INSERT INTO service_item (item_name, description, price, status, create_time, update_time)
SELECT '轮胎更换', '更换前后轮胎，包含动平衡', 500.00, 1, NOW(), NOW()
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM service_item WHERE item_name = '轮胎更换');

-- 第4步：验证数据
SELECT '✅ 执行完成！请查看下面的数据验证：' as result;
SELECT '' as '';

SELECT '=== 商家数据 ===' as info;
SELECT id, merchant_name, contact_name, contact_phone, status FROM merchant;

SELECT '=== 服务项目数据 ===' as info;
SELECT id, item_name, price, status FROM service_item;

SELECT '=== 数据统计 ===' as info;
SELECT 
    (SELECT COUNT(*) FROM merchant) as merchant_count,
    (SELECT COUNT(*) FROM service_item) as service_item_count,
    (SELECT COUNT(*) FROM sys_user WHERE user_type=2) as merchant_user_count;




