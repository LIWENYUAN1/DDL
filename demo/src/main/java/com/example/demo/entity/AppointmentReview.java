package com.example.demo.entity;

import com.baomidou.mybatisplus.annotation.*;
import lombok.Data;

import java.io.Serializable;
import java.time.LocalDateTime;

/**
 * 预约评价实体类
 */
@Data
@TableName("appointment_review")
public class AppointmentReview implements Serializable {

    private static final long serialVersionUID = 1L;

    /**
     * 评价ID（主键）
     */
    @TableId(type = IdType.AUTO)
    private Long id;

    /**
     * 预约ID
     */
    private Long appointmentId;

    /**
     * 用户ID
     */
    private Long userId;

    /**
     * 商家ID
     */
    private Long merchantId;

    /**
     * 综合评分（1-5分）
     */
    private Integer score;

    /**
     * 服务评分（1-5分）
     */
    private Integer serviceScore;

    /**
     * 质量评分（1-5分）
     */
    private Integer qualityScore;

    /**
     * 态度评分（1-5分）
     */
    private Integer attitudeScore;

    /**
     * 评价内容
     */
    private String content;

    /**
     * 评价图片URL（多个用逗号分隔）
     */
    private String imgUrls;

    /**
     * 商家回复内容
     */
    private String replyContent;

    /**
     * 商家回复时间
     */
    private LocalDateTime replyTime;

    /**
     * 状态：0-隐藏，1-显示
     */
    private Integer status;

    /**
     * 是否匿名：0-否，1-是
     */
    private Integer isAnonymous;

    /**
     * 创建时间
     */
    @TableField(fill = FieldFill.INSERT)
    private LocalDateTime createTime;

    /**
     * 更新时间
     */
    @TableField(fill = FieldFill.INSERT_UPDATE)
    private LocalDateTime updateTime;

    // ===== 以下为非数据库字段，用于查询时关联数据 =====

    /**
     * 用户名（非数据库字段）
     */
    @TableField(exist = false)
    private String username;

    /**
     * 商家名称（非数据库字段）
     */
    @TableField(exist = false)
    private String merchantName;

    /**
     * 预约单号（非数据库字段）
     */
    @TableField(exist = false)
    private String orderNo;

    /**
     * 服务项目名称（非数据库字段）
     */
    @TableField(exist = false)
    private String serviceItemName;
}


