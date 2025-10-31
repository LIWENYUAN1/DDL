-- ============================================
-- 终极修复SQL - 自动处理重复数据
-- ============================================

USE motorcycle_service_platform;

-- 第1步：插入或更新商家用户（避免手机号重复）
INSERT INTO sys_user (username, password, phone, user_type, status, create_time, update_time)
VALUES ('merchant_shop1', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z2EE4lb8Qrx7hQo3DqsFy2/u', '13900000099', 2, 1, NOW(), NOW())
ON DUPLICATE KEY UPDATE 
    password = VALUES(password),
    user_type = VALUES(user_type),
    status = VALUES(status),
    update_time = NOW();

-- 第2步：获取或创建商家数据
-- 方案：使用现有的商家用户，或者刚创建的
DELETE FROM merchant WHERE merchant_name = '测试摩托维修店';

INSERT INTO merchant (
    merchant_name, 
    user_id, 
    contact_name, 
    contact_phone, 
    address, 
    latitude, 
    longitude, 
    location, 
    business_hours, 
    merchant_type, 
    status,
    create_time,
    update_time
)
SELECT 
    '测试摩托维修店',
    u.id,
    '张师傅',
    '13900139999',
    '北京市朝阳区建国路88号',
    39.904200,
    116.407396,
    ST_GeomFromText('POINT(116.407396 39.904200)'),
    '09:00-20:00',
    1,
    1,
    NOW(),
    NOW()
FROM sys_user u
WHERE u.user_type = 2
LIMIT 1;

-- 第3步：插入服务项目（避免重复）
INSERT INTO service_item (item_name, description, price, status, create_time, update_time)
VALUES ('常规保养', '更换机油、机滤、空滤，检查刹车系统', 200.00, 1, NOW(), NOW())
ON DUPLICATE KEY UPDATE 
    description = VALUES(description),
    price = VALUES(price),
    update_time = NOW();

INSERT INTO service_item (item_name, description, price, status, create_time, update_time)
VALUES ('刹车维护', '检查更换刹车片、刹车盘和刹车油', 300.00, 1, NOW(), NOW())
ON DUPLICATE KEY UPDATE 
    description = VALUES(description),
    price = VALUES(price),
    update_time = NOW();

INSERT INTO service_item (item_name, description, price, status, create_time, update_time)
VALUES ('轮胎更换', '更换前后轮胎，包含动平衡', 500.00, 1, NOW(), NOW())
ON DUPLICATE KEY UPDATE 
    description = VALUES(description),
    price = VALUES(price),
    update_time = NOW();

-- 第4步：验证数据
SELECT '========== 数据验证 ==========' as '';
SELECT '' as '';

SELECT '商家用户数据：' as info;
SELECT id, username, phone, user_type, status FROM sys_user WHERE user_type = 2;

SELECT '' as '';
SELECT '商家信息：' as info;
SELECT id, merchant_name, contact_name, contact_phone, merchant_type, status FROM merchant;

SELECT '' as '';
SELECT '服务项目：' as info;
SELECT id, item_name, price, status FROM service_item;

SELECT '' as '';
SELECT '数据统计：' as info;
SELECT 
    (SELECT COUNT(*) FROM merchant) as merchant_count,
    (SELECT COUNT(*) FROM service_item) as service_item_count,
    (SELECT COUNT(*) FROM sys_user WHERE user_type=2) as merchant_user_count;

SELECT '' as '';
SELECT '✅ 全部完成！可以启动后端测试了！' as result;




