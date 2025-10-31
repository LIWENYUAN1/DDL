-- ===================================================
-- 创建预约相关表 - 立即执行此SQL
-- ===================================================

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for appointment
-- ----------------------------
DROP TABLE IF EXISTS `appointment`;
CREATE TABLE `appointment` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '预约ID（主键）',
  `order_no` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '预约单号（唯一）',
  `user_id` bigint NOT NULL COMMENT '用户ID（关联sys_user表）',
  `merchant_id` bigint NOT NULL COMMENT '商家ID（关联merchant表）',
  `motorcycle_id` bigint NOT NULL COMMENT '车辆ID（关联motorcycle表）',
  `appointment_time` datetime NOT NULL COMMENT '预约服务时间',
  `appointment_type` tinyint NOT NULL DEFAULT 2 COMMENT '预约类型：1-立即服务，2-预约服务',
  `service_type` tinyint NOT NULL DEFAULT 1 COMMENT '服务方式：1-到店服务，2-上门服务',
  `service_address` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '服务地址',
  `contact_phone` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '联系电话',
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '问题描述',
  `remark` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '备注',
  `status` tinyint NOT NULL DEFAULT 0 COMMENT '预约状态：0-待确认，1-已确认，2-进行中，3-已完成，4-已取消',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_order_no`(`order_no` ASC) USING BTREE,
  INDEX `idx_user_id`(`user_id` ASC) USING BTREE,
  INDEX `idx_merchant_id`(`merchant_id` ASC) USING BTREE,
  INDEX `idx_motorcycle_id`(`motorcycle_id` ASC) USING BTREE,
  INDEX `idx_appointment_time`(`appointment_time` ASC) USING BTREE,
  INDEX `idx_status`(`status` ASC) USING BTREE,
  CONSTRAINT `fk_appointment_user` FOREIGN KEY (`user_id`) REFERENCES `sys_user` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `fk_appointment_merchant` FOREIGN KEY (`merchant_id`) REFERENCES `merchant` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `fk_appointment_motorcycle` FOREIGN KEY (`motorcycle_id`) REFERENCES `motorcycle` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '预约信息表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for appointment_service_item
-- ----------------------------
DROP TABLE IF EXISTS `appointment_service_item`;
CREATE TABLE `appointment_service_item` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `appointment_id` bigint NOT NULL COMMENT '预约ID（关联appointment表）',
  `service_item_id` bigint NOT NULL COMMENT '服务项目ID（关联service_item表）',
  `service_price` decimal(10,2) NULL DEFAULT NULL COMMENT '服务价格（元）',
  `quantity` int NOT NULL DEFAULT 1 COMMENT '数量（默认1）',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_appointment_id`(`appointment_id` ASC) USING BTREE,
  INDEX `idx_service_item_id`(`service_item_id` ASC) USING BTREE,
  CONSTRAINT `fk_appointment_service_appointment` FOREIGN KEY (`appointment_id`) REFERENCES `appointment` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT,
  CONSTRAINT `fk_appointment_service_item` FOREIGN KEY (`service_item_id`) REFERENCES `service_item` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '预约服务项目关联表' ROW_FORMAT = Dynamic;

SET FOREIGN_KEY_CHECKS = 1;

-- ===================================================
-- 表创建完成！
-- ===================================================

SELECT 'appointment 表创建成功！' AS 结果;
SELECT 'appointment_service_item 表创建成功！' AS 结果;


