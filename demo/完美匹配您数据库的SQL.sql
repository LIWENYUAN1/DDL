-- ============================================
-- 完美匹配您的数据库结构 - 基于DDL.txt
-- ============================================

USE motorcycle_service_platform;

-- 第1步：确保有商家用户（使用已存在的DDL123用户，id=5）
-- 检查：SELECT * FROM sys_user WHERE user_type = 2;
-- 已存在：id=5, username='DDL123', user_type=2

-- 第2步：为已存在的商家(id=1)更新或插入新商家供测试使用
-- 因为merchant表的id=1已经存在且user_id=1(admin)，我们插入一个新的测试商家

-- 方案A：插入新的测试商家（使用DDL123用户）
DELETE FROM merchant WHERE user_id = 5;  -- 清理可能存在的旧数据

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
    license_img,
    description,
    avg_score,
    comment_count,
    status
) VALUES (
    'DDL测试维修店',
    5,  -- 使用已存在的商家用户DDL123
    '李师傅',
    '13008620788',
    '北京市朝阳区建国路99号',
    39.904200,
    116.407396,
    ST_GeomFromText('POINT(116.407396 39.904200)'),
    '08:00-21:00',
    1,  -- 维修店
    NULL,
    '专业摩托车维修保养服务',
    4.8,
    15,
    1  -- 已通过
);

-- 获取刚插入的商家ID
SET @test_merchant_id = LAST_INSERT_ID();

-- 第3步：插入服务项目（必须关联merchant_id和category_id）
-- 使用刚创建的商家和已存在的类目

-- 清理可能存在的测试数据
DELETE FROM service_item WHERE merchant_id = @test_merchant_id;

-- 插入基础保养服务（类目id=1：基础保养）
INSERT INTO service_item (
    merchant_id,
    category_id,
    item_name,
    price,
    duration,
    description,
    cover_img,
    stock,
    status
) VALUES 
(
    @test_merchant_id,
    6,  -- 更换机油（service_category id=6）
    '常规保养套餐',
    200.00,
    60,
    '包含更换机油、机滤、空滤，全车检查',
    NULL,
    -1,
    1
),
(
    @test_merchant_id,
    8,  -- 轮胎更换（service_category id=8）
    '刹车系统维护',
    300.00,
    90,
    '检查更换刹车片、刹车盘和刹车油',
    NULL,
    -1,
    1
),
(
    @test_merchant_id,
    8,  -- 轮胎更换类目
    '轮胎更换服务',
    500.00,
    120,
    '更换前后轮胎，包含动平衡和轮胎检测',
    NULL,
    -1,
    1
),
(
    @test_merchant_id,
    7,  -- 更换滤芯（service_category id=7）
    '链条深度保养',
    150.00,
    45,
    '清洁、润滑、调整传动链，延长使用寿命',
    NULL,
    -1,
    1
);

-- 第4步：同时也为原有商家(id=1)插入服务项目
DELETE FROM service_item WHERE merchant_id = 1;

INSERT INTO service_item (
    merchant_id,
    category_id,
    item_name,
    price,
    duration,
    description,
    status
) VALUES 
(
    1,  -- 极速摩托维修店
    6,  -- 更换机油
    '机油更换服务',
    180.00,
    30,
    '使用优质机油，专业更换服务',
    1
),
(
    1,
    8,  -- 轮胎更换
    '刹车保养',
    280.00,
    60,
    '全面检查刹车系统，确保行车安全',
    1
);

-- 第5步：验证数据
SELECT '========== 数据验证 ==========' as '';
SELECT '' as '';

SELECT '商家用户：' as info;
SELECT id, username, phone, user_type, status 
FROM sys_user 
WHERE user_type = 2;

SELECT '' as '';
SELECT '商家信息：' as info;
SELECT id, merchant_name, user_id, contact_name, contact_phone, merchant_type, status 
FROM merchant;

SELECT '' as '';
SELECT '服务项目（含商家关联）：' as info;
SELECT 
    si.id,
    si.merchant_id,
    m.merchant_name,
    si.item_name,
    si.price,
    sc.category_name,
    si.status
FROM service_item si
LEFT JOIN merchant m ON si.merchant_id = m.id
LEFT JOIN service_category sc ON si.category_id = sc.id
ORDER BY si.merchant_id, si.id;

SELECT '' as '';
SELECT '数据统计：' as info;
SELECT 
    (SELECT COUNT(*) FROM merchant) as merchant_count,
    (SELECT COUNT(*) FROM service_item) as service_item_count,
    (SELECT COUNT(*) FROM sys_user WHERE user_type=2) as merchant_user_count,
    (SELECT COUNT(*) FROM service_category) as category_count;

SELECT '' as '';
SELECT '✅ 数据初始化完成！现在可以测试预约功能了！' as result;
SELECT '' as '';
SELECT '提示：预约时可以使用以下merchant_id：' as tip;
SELECT id as merchant_id, merchant_name FROM merchant WHERE status = 1;




