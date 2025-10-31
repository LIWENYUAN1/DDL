-- ============================================
-- 正确的测试数据（匹配实际表结构）
-- ============================================

USE motorcycle_service_platform;

-- 1. 插入测试商家数据（匹配实际表结构）
-- 注意：merchant表需要user_id，所以我们先创建一个商家用户
INSERT INTO sys_user (username, password, phone, user_type, status, create_time, update_time)
VALUES ('merchant_test', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z2EE4lb8Qrx7hQo3DqsFy2/u', '13900000001', 2, 1, NOW(), NOW())
ON DUPLICATE KEY UPDATE username=VALUES(username);

-- 获取刚插入的用户ID（或使用已存在的商家用户ID）
SET @merchant_user_id = (SELECT id FROM sys_user WHERE username = 'merchant_test' LIMIT 1);

-- 插入商家数据（使用实际的表字段）
INSERT INTO merchant (
    id, 
    merchant_name, 
    user_id,
    contact_name,           -- 注意：是 contact_name 不是 contact_person
    contact_phone, 
    address, 
    latitude,               -- 必填：纬度
    longitude,              -- 必填：经度
    location,               -- 必填：地理位置
    business_hours,         -- 必填：营业时间
    merchant_type,          -- 必填：商家类型
    license_img,
    description,
    avg_score,
    comment_count,
    status, 
    create_time, 
    update_time
)
VALUES (
    1,
    '测试摩托维修店',
    @merchant_user_id,
    '张师傅',               -- contact_name
    '13900139000',
    '北京市朝阳区建国路88号',
    39.904200,              -- 北京纬度
    116.407396,             -- 北京经度
    ST_GeomFromText('POINT(116.407396 39.904200)'),  -- 地理位置
    '09:00-20:00',          -- 营业时间
    1,                      -- 商家类型：1-维修店
    NULL,
    '专业摩托车维修保养',
    4.5,
    10,
    1,                      -- 状态：1-已通过
    NOW(), 
    NOW()
)
ON DUPLICATE KEY UPDATE 
    merchant_name=VALUES(merchant_name),
    contact_name=VALUES(contact_name),
    update_time=NOW();

-- 2. 插入服务项目数据
INSERT INTO service_item (id, item_name, description, price, status, create_time, update_time)
VALUES 
(1, '常规保养', '更换机油、机滤、空滤，检查刹车系统', 200.00, 1, NOW(), NOW()),
(2, '刹车维护', '检查更换刹车片、刹车盘和刹车油', 300.00, 1, NOW(), NOW()),
(3, '轮胎更换', '更换前后轮胎，包含动平衡', 500.00, 1, NOW(), NOW()),
(4, '链条保养', '清洁、润滑、调整传动链', 100.00, 1, NOW(), NOW())
ON DUPLICATE KEY UPDATE 
    item_name=VALUES(item_name),
    description=VALUES(description),
    price=VALUES(price),
    update_time=NOW();

-- 3. 验证数据插入
SELECT '=== 商家数据验证 ===' as info;
SELECT id, merchant_name, contact_name, contact_phone, merchant_type, status FROM merchant WHERE id = 1;

SELECT '=== 服务项目数据验证 ===' as info;
SELECT id, item_name, description, price, status FROM service_item WHERE id <= 4;

SELECT '=== 用户数据验证 ===' as info;
SELECT id, username, phone, user_type, status FROM sys_user ORDER BY id DESC LIMIT 5;

-- 显示统计信息
SELECT 
    '数据统计' as info,
    (SELECT COUNT(*) FROM merchant) as merchant_count,
    (SELECT COUNT(*) FROM service_item) as service_item_count,
    (SELECT COUNT(*) FROM sys_user) as user_count;

SELECT '✅ 测试数据插入完成！' as result;




