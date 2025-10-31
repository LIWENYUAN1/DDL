-- Initialize test data for motorcycle service platform

-- Check and create merchant if not exists
INSERT IGNORE INTO merchant (id, merchant_name, contact_person, contact_phone, address, business_license, status, create_time, update_time)
VALUES (1, '测试维修店', '张三', '13800138000', '测试地址123号', 'TEST123', 1, NOW(), NOW());

-- Check and create service_item if not exists
INSERT IGNORE INTO service_item (id, item_name, description, price, status, create_time, update_time)
VALUES (1, '常规保养', '更换机油、机滤等基础保养', 200.00, 1, NOW(), NOW());

INSERT IGNORE INTO service_item (id, item_name, description, price, status, create_time, update_time)
VALUES (2, '刹车维护', '检查更换刹车片和刹车油', 300.00, 1, NOW(), NOW());

-- Verify tables exist
SELECT 'merchant table check:' as info, COUNT(*) as count FROM merchant;
SELECT 'service_item table check:' as info, COUNT(*) as count FROM service_item;
SELECT 'sys_user table check:' as info, COUNT(*) as count FROM sys_user;
SELECT 'appointment table exists:' as info;

-- Show table structure
SHOW CREATE TABLE appointment;




