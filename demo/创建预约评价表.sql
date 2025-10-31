-- 创建预约评价表
-- 用于用户对已完成的预约进行评价

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for appointment_review
-- ----------------------------
DROP TABLE IF EXISTS `appointment_review`;
CREATE TABLE `appointment_review`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '评价ID（主键）',
  `appointment_id` bigint NOT NULL COMMENT '关联appointment表的id（唯一，一个预约对应一条评价）',
  `user_id` bigint NOT NULL COMMENT '关联sys_user表的id（评价用户）',
  `merchant_id` bigint NOT NULL COMMENT '关联merchant表的id（被评价商家）',
  `score` tinyint NOT NULL COMMENT '评分（1-5分）',
  `service_score` tinyint NULL DEFAULT NULL COMMENT '服务评分（1-5分）',
  `quality_score` tinyint NULL DEFAULT NULL COMMENT '质量评分（1-5分）',
  `attitude_score` tinyint NULL DEFAULT NULL COMMENT '态度评分（1-5分）',
  `content` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '评价内容',
  `img_urls` varchar(1000) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '评价图片URL（多个用逗号分隔）',
  `reply_content` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '商家回复内容',
  `reply_time` datetime NULL DEFAULT NULL COMMENT '商家回复时间',
  `status` tinyint NOT NULL DEFAULT 1 COMMENT '状态：0-隐藏，1-显示',
  `is_anonymous` tinyint NOT NULL DEFAULT 0 COMMENT '是否匿名：0-否，1-是',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_appointment_id`(`appointment_id` ASC) USING BTREE COMMENT '一个预约只能评价一次',
  INDEX `idx_user_id`(`user_id` ASC) USING BTREE,
  INDEX `idx_merchant_id`(`merchant_id` ASC) USING BTREE,
  INDEX `idx_score`(`score` ASC) USING BTREE,
  INDEX `idx_create_time`(`create_time` ASC) USING BTREE,
  CONSTRAINT `fk_review_appointment` FOREIGN KEY (`appointment_id`) REFERENCES `appointment` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT,
  CONSTRAINT `fk_review_user` FOREIGN KEY (`user_id`) REFERENCES `sys_user` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `fk_review_merchant` FOREIGN KEY (`merchant_id`) REFERENCES `merchant` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '预约评价表' ROW_FORMAT = Dynamic;

SET FOREIGN_KEY_CHECKS = 1;


