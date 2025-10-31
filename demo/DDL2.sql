/*
 Navicat Premium Dump SQL

 Source Server         : localhost
 Source Server Type    : MySQL
 Source Server Version : 80043 (8.0.43)
 Source Host           : localhost:3306
 Source Schema         : motorcycle_service_platform

 Target Server Type    : MySQL
 Target Server Version : 80043 (8.0.43)
 File Encoding         : 65001

 Date: 30/10/2025 12:07:51
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for appointment
-- ----------------------------
DROP TABLE IF EXISTS `appointment`;
CREATE TABLE `appointment`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '预约ID（主键）',
  `order_no` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '预约单号（唯一）',
  `user_id` bigint NOT NULL COMMENT '用户ID',
  `merchant_id` bigint NOT NULL COMMENT '商家ID',
  `motorcycle_id` bigint NOT NULL COMMENT '车辆ID',
  `appointment_time` datetime NOT NULL COMMENT '预约服务时间',
  `appointment_type` tinyint NOT NULL DEFAULT 2 COMMENT '预约类型：1-立即服务，2-预约服务',
  `service_type` tinyint NOT NULL DEFAULT 1 COMMENT '服务方式：1-到店服务，2-上门服务',
  `service_address` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '服务地址',
  `contact_phone` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '联系电话',
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '问题描述',
  `remark` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '备注',
  `status` tinyint NOT NULL DEFAULT 0 COMMENT '预约状态：0-待确认，1-已确认，2-进行中，3-已完成，4-已取消',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_order_no`(`order_no` ASC) USING BTREE,
  INDEX `idx_user_id`(`user_id` ASC) USING BTREE,
  INDEX `idx_merchant_id`(`merchant_id` ASC) USING BTREE,
  INDEX `idx_motorcycle_id`(`motorcycle_id` ASC) USING BTREE,
  INDEX `idx_status`(`status` ASC) USING BTREE,
  CONSTRAINT `fk_appointment_merchant` FOREIGN KEY (`merchant_id`) REFERENCES `merchant` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `fk_appointment_motorcycle` FOREIGN KEY (`motorcycle_id`) REFERENCES `motorcycle` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `fk_appointment_user` FOREIGN KEY (`user_id`) REFERENCES `sys_user` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 2 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '预约信息表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of appointment
-- ----------------------------

-- ----------------------------
-- Table structure for appointment_service_item
-- ----------------------------
DROP TABLE IF EXISTS `appointment_service_item`;
CREATE TABLE `appointment_service_item`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `appointment_id` bigint NOT NULL COMMENT '预约ID',
  `service_item_id` bigint NOT NULL COMMENT '服务项目ID',
  `service_price` decimal(10, 2) NULL DEFAULT NULL COMMENT '服务价格',
  `quantity` int NOT NULL DEFAULT 1 COMMENT '数量',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_appointment_id`(`appointment_id` ASC) USING BTREE,
  INDEX `idx_service_item_id`(`service_item_id` ASC) USING BTREE,
  CONSTRAINT `fk_appointment_service_appointment` FOREIGN KEY (`appointment_id`) REFERENCES `appointment` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT,
  CONSTRAINT `fk_appointment_service_item` FOREIGN KEY (`service_item_id`) REFERENCES `service_item` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 2 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '预约服务项目关联表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of appointment_service_item
-- ----------------------------

-- ----------------------------
-- Table structure for merchant
-- ----------------------------
DROP TABLE IF EXISTS `merchant`;
CREATE TABLE `merchant`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '商家ID（主键）',
  `merchant_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '商家名称（唯一）',
  `user_id` bigint NOT NULL COMMENT '关联sys_user表的id（商家管理员）',
  `contact_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '联系人',
  `contact_phone` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '联系电话',
  `address` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '详细地址',
  `latitude` decimal(10, 6) NOT NULL COMMENT '纬度（LBS定位，用于附近搜索）',
  `longitude` decimal(10, 6) NOT NULL COMMENT '经度（LBS定位）',
  `location` point NOT NULL COMMENT '地理位置（经纬度聚合，用于空间索引）',
  `business_hours` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '营业时间（如：09:00-19:00）',
  `merchant_type` tinyint NOT NULL COMMENT '商家类型：1-维修店，2-保养店，3-改装店，4-托运服务，5-综合店',
  `license_img` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '营业执照图片URL',
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '商家简介',
  `avg_score` decimal(2, 1) NULL DEFAULT 0.0 COMMENT '平均评分（0-5分）',
  `comment_count` int NULL DEFAULT 0 COMMENT '评价数量',
  `status` tinyint NOT NULL DEFAULT 0 COMMENT '状态：0-待审核，1-已通过，2-已驳回，3-已关闭',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_merchant_name`(`merchant_name` ASC) USING BTREE,
  UNIQUE INDEX `uk_merchant_user_id`(`user_id` ASC) USING BTREE,
  INDEX `idx_merchant_type`(`merchant_type` ASC) USING BTREE,
  INDEX `idx_merchant_status`(`status` ASC) USING BTREE,
  SPATIAL INDEX `idx_merchant_location`(`location`),
  INDEX `idx_merchant_lat_lng`(`latitude` ASC, `longitude` ASC) USING BTREE,
  CONSTRAINT `fk_merchant_user` FOREIGN KEY (`user_id`) REFERENCES `sys_user` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 3 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '商家信息表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of merchant
-- ----------------------------
INSERT INTO `merchant` VALUES (1, '极速摩托维修店', 1, '张三', '13900139000', '云南省大理市下关镇幸福路100号', 25.686611, 100.189444, ST_GeomFromText('POINT(100.189444 25.686611)'), '09:00-20:00', 1, NULL, NULL, 0.0, 0, 1, '2025-10-19 23:10:54', '2025-10-19 23:10:54');
INSERT INTO `merchant` VALUES (2, 'DDL测试维修店', 5, '李师傅', '13008620788', '北京市朝阳区建国路99号', 39.904200, 116.407396, ST_GeomFromText('POINT(116.407396 39.9042)'), '08:00-21:00', 1, NULL, NULL, 0.0, 0, 1, '2025-10-29 20:59:41', '2025-10-29 20:59:41');

-- ----------------------------
-- Table structure for merchant_workstation
-- ----------------------------
DROP TABLE IF EXISTS `merchant_workstation`;
CREATE TABLE `merchant_workstation`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '工位ID（主键）',
  `merchant_id` bigint NOT NULL COMMENT '关联merchant表的id',
  `workstation_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '工位名称（如：维修工位1、保养工位2）',
  `max_reserve` int NOT NULL DEFAULT 1 COMMENT '同一时间段最大预约数（默认1，避免冲突）',
  `status` tinyint NOT NULL DEFAULT 1 COMMENT '状态：0-停用，1-启用',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_merchant_id`(`merchant_id` ASC) USING BTREE,
  CONSTRAINT `fk_workstation_merchant` FOREIGN KEY (`merchant_id`) REFERENCES `merchant` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '商家工位表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of merchant_workstation
-- ----------------------------

-- ----------------------------
-- Table structure for motorcycle
-- ----------------------------
DROP TABLE IF EXISTS `motorcycle`;
CREATE TABLE `motorcycle`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '车辆ID（主键）',
  `owner_id` bigint NOT NULL COMMENT '关联owner_info表的id（车主）',
  `license_plate` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '车牌号（可选，允许无牌车）',
  `brand` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '品牌（如：本田、雅马哈）',
  `model` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '车型（如：CB400X、YZF-R3）',
  `displacement` decimal(5, 1) NULL DEFAULT NULL COMMENT '排量（单位：cc）',
  `purchase_time` date NULL DEFAULT NULL COMMENT '购买日期',
  `vin` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '车辆识别码（VIN，唯一）',
  `status` tinyint NOT NULL DEFAULT 1 COMMENT '状态：0-已注销，1-正常使用',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_vin`(`vin` ASC) USING BTREE,
  INDEX `idx_owner_id`(`owner_id` ASC) USING BTREE,
  CONSTRAINT `fk_motorcycle_owner` FOREIGN KEY (`owner_id`) REFERENCES `owner_info` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 6 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '摩托车信息表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of motorcycle
-- ----------------------------

-- ----------------------------
-- Table structure for order_item
-- ----------------------------
DROP TABLE IF EXISTS `order_item`;
CREATE TABLE `order_item`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '明细ID（主键）',
  `order_id` bigint NOT NULL COMMENT '关联order_main表的id',
  `service_item_id` bigint NOT NULL COMMENT '关联service_item表的id',
  `item_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '服务名称（冗余存储，避免服务项修改影响订单）',
  `item_price` decimal(10, 2) NOT NULL COMMENT '服务单价（元，下单时的价格）',
  `quantity` int NOT NULL DEFAULT 1 COMMENT '购买数量（默认1）',
  `sub_amount` decimal(10, 2) NOT NULL COMMENT '子项金额（单价×数量）',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_order_id`(`order_id` ASC) USING BTREE,
  INDEX `idx_service_item_id`(`service_item_id` ASC) USING BTREE,
  CONSTRAINT `fk_order_item_main` FOREIGN KEY (`order_id`) REFERENCES `order_main` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT,
  CONSTRAINT `fk_order_item_service` FOREIGN KEY (`service_item_id`) REFERENCES `service_item` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '订单明细表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of order_item
-- ----------------------------

-- ----------------------------
-- Table structure for order_main
-- ----------------------------
DROP TABLE IF EXISTS `order_main`;
CREATE TABLE `order_main`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '订单ID（主键）',
  `order_no` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '订单编号（唯一，如：ORD20250101123456）',
  `owner_id` bigint NOT NULL COMMENT '关联owner_info表的id（下单车主）',
  `motorcycle_id` bigint NOT NULL COMMENT '关联motorcycle表的id（服务车辆）',
  `merchant_id` bigint NOT NULL COMMENT '关联merchant表的id（服务商家）',
  `total_amount` decimal(10, 2) NOT NULL COMMENT '订单总金额（元）',
  `pay_amount` decimal(10, 2) NOT NULL COMMENT '实际支付金额（元）',
  `discount_amount` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '优惠金额（元）',
  `order_status` tinyint NOT NULL COMMENT '订单状态：0-待支付，1-已支付，2-服务中，3-已完成，4-已取消，5-已退款',
  `pay_type` tinyint NULL DEFAULT NULL COMMENT '支付方式：1-微信支付，2-支付宝支付，3-线下支付',
  `pay_time` datetime NULL DEFAULT NULL COMMENT '支付时间',
  `appoint_date` date NOT NULL COMMENT '预约日期',
  `appoint_time` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '预约时间段（如：09:00-10:00）',
  `service_address` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '服务地址（默认商家地址，异地托运时可自定义）',
  `contact_phone` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '订单联系人电话',
  `remark` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '车主备注',
  `merchant_remark` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '商家备注',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_order_no`(`order_no` ASC) USING BTREE,
  INDEX `idx_owner_id`(`owner_id` ASC) USING BTREE,
  INDEX `idx_merchant_id`(`merchant_id` ASC) USING BTREE,
  INDEX `idx_order_status`(`order_status` ASC) USING BTREE,
  INDEX `idx_appoint_date`(`appoint_date` ASC) USING BTREE,
  INDEX `fk_order_motorcycle`(`motorcycle_id` ASC) USING BTREE,
  CONSTRAINT `fk_order_merchant` FOREIGN KEY (`merchant_id`) REFERENCES `merchant` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `fk_order_motorcycle` FOREIGN KEY (`motorcycle_id`) REFERENCES `motorcycle` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `fk_order_owner` FOREIGN KEY (`owner_id`) REFERENCES `owner_info` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '订单主表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of order_main
-- ----------------------------

-- ----------------------------
-- Table structure for owner_info
-- ----------------------------
DROP TABLE IF EXISTS `owner_info`;
CREATE TABLE `owner_info`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `user_id` bigint NOT NULL COMMENT '关联sys_user表的id',
  `id_card` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '身份证号（可选）',
  `address` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '常用地址',
  `latitude` decimal(10, 6) NULL DEFAULT NULL COMMENT '常用地址纬度（LBS定位）',
  `longitude` decimal(10, 6) NULL DEFAULT NULL COMMENT '常用地址经度（LBS定位）',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_user_id`(`user_id` ASC) USING BTREE,
  INDEX `idx_owner_location`(`latitude` ASC, `longitude` ASC) USING BTREE,
  CONSTRAINT `fk_owner_user` FOREIGN KEY (`user_id`) REFERENCES `sys_user` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 4 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '车主信息表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of owner_info
-- ----------------------------

-- ----------------------------
-- Table structure for pay_record
-- ----------------------------
DROP TABLE IF EXISTS `pay_record`;
CREATE TABLE `pay_record`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '记录ID（主键）',
  `order_id` bigint NOT NULL COMMENT '关联order_main表的id',
  `order_no` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '订单编号（冗余）',
  `pay_no` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '第三方支付流水号（如微信/支付宝订单号）',
  `pay_amount` decimal(10, 2) NOT NULL COMMENT '支付金额（元）',
  `pay_type` tinyint NOT NULL COMMENT '支付方式：1-微信支付，2-支付宝支付，3-线下支付',
  `pay_status` tinyint NOT NULL COMMENT '支付状态：0-支付中，1-支付成功，2-支付失败',
  `pay_time` datetime NULL DEFAULT NULL COMMENT '支付完成时间',
  `callback_data` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '第三方支付回调数据（JSON格式）',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_order_id`(`order_id` ASC) USING BTREE,
  INDEX `idx_pay_no`(`pay_no` ASC) USING BTREE,
  INDEX `idx_pay_status`(`pay_status` ASC) USING BTREE,
  CONSTRAINT `fk_pay_order` FOREIGN KEY (`order_id`) REFERENCES `order_main` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '支付记录表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of pay_record
-- ----------------------------

-- ----------------------------
-- Table structure for reserve_occupy
-- ----------------------------
DROP TABLE IF EXISTS `reserve_occupy`;
CREATE TABLE `reserve_occupy`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '占用ID（主键）',
  `merchant_id` bigint NOT NULL COMMENT '关联merchant表的id',
  `workstation_id` bigint NOT NULL COMMENT '关联merchant_workstation表的id',
  `order_id` bigint NOT NULL COMMENT '关联order_main表的id',
  `appoint_date` date NOT NULL COMMENT '预约日期',
  `appoint_time` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '预约时间段（如：09:00-10:00）',
  `occupy_status` tinyint NOT NULL DEFAULT 1 COMMENT '占用状态：1-已占用，2-已释放',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_reserve_unique`(`merchant_id` ASC, `workstation_id` ASC, `appoint_date` ASC, `appoint_time` ASC, `occupy_status` ASC) USING BTREE COMMENT '同一工位同一时间段只能占用一次',
  INDEX `idx_order_id`(`order_id` ASC) USING BTREE,
  INDEX `idx_appoint_date`(`appoint_date` ASC) USING BTREE,
  INDEX `fk_occupy_workstation`(`workstation_id` ASC) USING BTREE,
  CONSTRAINT `fk_occupy_merchant` FOREIGN KEY (`merchant_id`) REFERENCES `merchant` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT,
  CONSTRAINT `fk_occupy_order` FOREIGN KEY (`order_id`) REFERENCES `order_main` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT,
  CONSTRAINT `fk_occupy_workstation` FOREIGN KEY (`workstation_id`) REFERENCES `merchant_workstation` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '预约占用表（解决并发冲突）' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of reserve_occupy
-- ----------------------------

-- ----------------------------
-- Table structure for service_category
-- ----------------------------
DROP TABLE IF EXISTS `service_category`;
CREATE TABLE `service_category`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '类目ID（主键）',
  `category_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '类目名称（如：基础保养）',
  `parent_id` bigint NULL DEFAULT 0 COMMENT '父类目ID（0-一级类目）',
  `sort` int NULL DEFAULT 0 COMMENT '排序权重（越大越靠前）',
  `status` tinyint NOT NULL DEFAULT 1 COMMENT '状态：0-禁用，1-启用',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_parent_id`(`parent_id` ASC) USING BTREE,
  INDEX `idx_status`(`status` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 16 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '服务类目表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of service_category
-- ----------------------------
INSERT INTO `service_category` VALUES (1, '基础保养', 0, 10, 1, '2025-10-19 23:10:54', '2025-10-19 23:10:54');
INSERT INTO `service_category` VALUES (2, '维修服务', 0, 20, 1, '2025-10-19 23:10:54', '2025-10-19 23:10:54');
INSERT INTO `service_category` VALUES (3, '改装升级', 0, 30, 1, '2025-10-19 23:10:54', '2025-10-19 23:10:54');
INSERT INTO `service_category` VALUES (4, '异地托运', 0, 40, 1, '2025-10-19 23:10:54', '2025-10-19 23:10:54');
INSERT INTO `service_category` VALUES (5, '美容清洗', 0, 50, 1, '2025-10-19 23:10:54', '2025-10-19 23:10:54');
INSERT INTO `service_category` VALUES (6, '更换机油', 1, 10, 1, '2025-10-19 23:10:54', '2025-10-19 23:10:54');
INSERT INTO `service_category` VALUES (7, '更换滤芯', 1, 20, 1, '2025-10-19 23:10:54', '2025-10-19 23:10:54');
INSERT INTO `service_category` VALUES (8, '轮胎更换', 2, 10, 1, '2025-10-19 23:10:54', '2025-10-19 23:10:54');
INSERT INTO `service_category` VALUES (9, '发动机维修', 2, 20, 1, '2025-10-19 23:10:54', '2025-10-19 23:10:54');
INSERT INTO `service_category` VALUES (10, '外观改装', 3, 10, 1, '2025-10-19 23:10:54', '2025-10-19 23:10:54');
INSERT INTO `service_category` VALUES (11, '性能升级', 3, 20, 1, '2025-10-19 23:10:54', '2025-10-19 23:10:54');
INSERT INTO `service_category` VALUES (12, '同城托运', 4, 10, 1, '2025-10-19 23:10:54', '2025-10-19 23:10:54');
INSERT INTO `service_category` VALUES (13, '跨省托运', 4, 20, 1, '2025-10-19 23:10:54', '2025-10-19 23:10:54');
INSERT INTO `service_category` VALUES (14, '车身清洗', 5, 10, 1, '2025-10-19 23:10:54', '2025-10-19 23:10:54');
INSERT INTO `service_category` VALUES (15, '漆面养护', 5, 20, 1, '2025-10-19 23:10:54', '2025-10-19 23:10:54');

-- ----------------------------
-- Table structure for service_evaluation
-- ----------------------------
DROP TABLE IF EXISTS `service_evaluation`;
CREATE TABLE `service_evaluation`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '评价ID（主键）',
  `order_id` bigint NOT NULL COMMENT '关联order_main表的id（唯一，一个订单对应一条评价）',
  `owner_id` bigint NOT NULL COMMENT '关联owner_info表的id（评价车主）',
  `merchant_id` bigint NOT NULL COMMENT '关联merchant表的id（被评价商家）',
  `score` tinyint NOT NULL COMMENT '评分（1-5分）',
  `content` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '评价内容',
  `img_urls` varchar(1000) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '评价图片URL（多个用逗号分隔）',
  `reply_content` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '商家回复内容',
  `reply_time` datetime NULL DEFAULT NULL COMMENT '商家回复时间',
  `status` tinyint NOT NULL DEFAULT 1 COMMENT '状态：0-隐藏，1-显示',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_order_id`(`order_id` ASC) USING BTREE,
  INDEX `idx_owner_id`(`owner_id` ASC) USING BTREE,
  INDEX `idx_merchant_id`(`merchant_id` ASC) USING BTREE,
  INDEX `idx_score`(`score` ASC) USING BTREE,
  CONSTRAINT `fk_evaluation_merchant` FOREIGN KEY (`merchant_id`) REFERENCES `merchant` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `fk_evaluation_order` FOREIGN KEY (`order_id`) REFERENCES `order_main` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT,
  CONSTRAINT `fk_evaluation_owner` FOREIGN KEY (`owner_id`) REFERENCES `owner_info` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '服务评价表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of service_evaluation
-- ----------------------------

-- ----------------------------
-- Table structure for service_item
-- ----------------------------
DROP TABLE IF EXISTS `service_item`;
CREATE TABLE `service_item`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '服务ID（主键）',
  `merchant_id` bigint NOT NULL COMMENT '关联merchant表的id',
  `category_id` bigint NOT NULL COMMENT '关联service_category表的id',
  `item_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '服务名称（如：更换机油、轮胎修补）',
  `price` decimal(10, 2) NOT NULL COMMENT '服务价格（元）',
  `duration` int NULL DEFAULT NULL COMMENT '预估时长（分钟，可选）',
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '服务详情描述',
  `cover_img` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '服务封面图片URL',
  `stock` int NULL DEFAULT -1 COMMENT '库存（-1表示不限，用于限量服务）',
  `status` tinyint NOT NULL DEFAULT 1 COMMENT '状态：0-下架，1-上架',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_merchant_id`(`merchant_id` ASC) USING BTREE,
  INDEX `idx_category_id`(`category_id` ASC) USING BTREE,
  INDEX `idx_status`(`status` ASC) USING BTREE,
  CONSTRAINT `fk_service_category` FOREIGN KEY (`category_id`) REFERENCES `service_category` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `fk_service_merchant` FOREIGN KEY (`merchant_id`) REFERENCES `merchant` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 5 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '服务项目表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of service_item
-- ----------------------------
INSERT INTO `service_item` VALUES (1, 2, 6, '常规保养套餐', 200.00, 60, '包含更换机油、机滤、空滤', NULL, -1, 1, '2025-10-29 20:59:41', '2025-10-29 20:59:41');
INSERT INTO `service_item` VALUES (2, 2, 8, '刹车系统维护', 300.00, 90, '检查更换刹车片刹车油', NULL, -1, 1, '2025-10-29 20:59:41', '2025-10-29 20:59:41');
INSERT INTO `service_item` VALUES (3, 1, 6, '机油更换服务', 180.00, 30, '使用优质机油', NULL, -1, 1, '2025-10-29 20:59:41', '2025-10-29 20:59:41');
INSERT INTO `service_item` VALUES (4, 1, 8, '刹车保养', 280.00, 60, '全面检查刹车系统', NULL, -1, 1, '2025-10-29 20:59:41', '2025-10-29 20:59:41');

-- ----------------------------
-- Table structure for sys_user
-- ----------------------------
DROP TABLE IF EXISTS `sys_user`;
CREATE TABLE `sys_user`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '用户ID（主键）',
  `username` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '用户名（唯一）',
  `password` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '加密后的密码（BCrypt算法）',
  `phone` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '手机号（唯一）',
  `email` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '邮箱（可选）',
  `real_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '真实姓名',
  `user_type` tinyint NOT NULL COMMENT '用户类型：1-车主，2-商家管理员，3-平台管理员',
  `status` tinyint NOT NULL DEFAULT 1 COMMENT '状态：0-禁用，1-正常',
  `avatar` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '头像URL',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_username`(`username` ASC) USING BTREE,
  UNIQUE INDEX `uk_phone`(`phone` ASC) USING BTREE,
  INDEX `idx_user_type`(`user_type` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 10 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '系统用户表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_user
-- ----------------------------
INSERT INTO `sys_user` VALUES (1, 'admin', '$2a$10$7Z8H8aG9Q7F6E5D4C3B2A1S0D9F8G7H6J5K4L3M2N1O0P9Q8R7', '13800138000', NULL, '平台管理员', 3, 1, NULL, '2025-10-19 23:10:54', '2025-10-19 23:10:54');
INSERT INTO `sys_user` VALUES (2, 'testuser', '$2a$10$gZx/rlvM8ZPWpgS.5BDMg.ZDuuF0LDwGwT7hFBk8qF0r8kX4GGVZ.', '13900139000', NULL, NULL, 1, 1, NULL, '2025-10-22 16:58:09', '2025-10-22 16:58:09');
INSERT INTO `sys_user` VALUES (3, 'testuser456', '$2a$10$hYdalvcdGLU7DCmMCfJgvudWNYS655JCu4GtVzRUEMQ83gz1MA57S', '13900001234', NULL, NULL, 1, 1, NULL, '2025-10-22 20:00:33', '2025-10-22 20:00:33');
INSERT INTO `sys_user` VALUES (4, 'admin123', '$2a$10$ouqnJ0TuPWvp7jzfkeoWV.XMj5nOIzd.2t5T5i7R/OfFNA7XWC1Bu', '13900000001', NULL, NULL, 3, 1, NULL, '2025-10-22 20:26:10', '2025-10-22 20:26:10');
INSERT INTO `sys_user` VALUES (5, 'DDL123', '$2a$10$tyzgW6itbjJ4LC5KZvbj5OzEK98AFZUJO/pGI6OzM7AROOIsnVEqu', '13008620788', NULL, NULL, 2, 1, NULL, '2025-10-22 20:29:53', '2025-10-22 20:29:53');
INSERT INTO `sys_user` VALUES (6, 'testuser529', '$2a$10$VBsABIDeW01OtvKPpe/r2e9eYNjUbd3iHyT9PAm3qvnP6jOo7a32i', '13860629565', NULL, NULL, 1, 1, NULL, '2025-10-28 20:17:53', '2025-10-28 20:17:53');
INSERT INTO `sys_user` VALUES (7, 'testuser850', '$2a$10$dspZeq6B9CPbfDmQ/C0jCeP6SAo5h3JkpVJj3RKOe/ZKE5XK7Bu1m', '13863188048', NULL, NULL, 1, 1, NULL, '2025-10-28 20:22:23', '2025-10-28 20:22:23');
INSERT INTO `sys_user` VALUES (8, 'newuser7790', '$2a$10$OHL/VJ4q7sfq0kd6AxQKXu.xdNW.FoOUqG0Hw50aE02uIPGTP9Yjm', '13845001732', NULL, NULL, 1, 1, NULL, '2025-10-29 20:01:27', '2025-10-29 20:01:27');

SET FOREIGN_KEY_CHECKS = 1;
