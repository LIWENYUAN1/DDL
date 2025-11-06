package com.mountain.entity;

import com.baomidou.mybatisplus.annotation.*;
import lombok.Data;

import java.io.Serializable;
import java.math.BigDecimal;
import java.time.LocalDateTime;

/**
 * 商家信息表
 */
@Data
@TableName("merchant")
public class Merchant implements Serializable {

    private static final long serialVersionUID = 1L;

    /**
     * 商家ID
     */
    @TableId(type = IdType.AUTO)
    private Long id;

    /**
     * 商家名称
     */
    private String merchantName;

    /**
     * 关联sys_user表的id（商家管理员）
     */
    private Long userId;

    /**
     * 联系人
     */
    private String contactName;

    /**
     * 联系电话
     */
    private String contactPhone;

    /**
     * 详细地址
     */
    private String address;

    /**
     * 纬度
     */
    private BigDecimal latitude;

    /**
     * 经度
     */
    private BigDecimal longitude;

    /**
     * 地理位置
     */
    private String location;

    /**
     * 营业时间
     */
    private String businessHours;

    /**
     * 商家类型：1-维修店，2-保养店，3-改装店，4-托运服务，5-综合店
     */
    private Integer merchantType;

    /**
     * 营业执照图片URL
     */
    private String licenseImg;

    /**
     * 商家简介
     */
    private String description;

    /**
     * 平均评分
     */
    private BigDecimal avgScore;

    /**
     * 评价数量
     */
    private Integer commentCount;

    /**
     * 状态：0-待审核，1-已通过，2-已驳回，3-已关闭
     */
    private Integer status;

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
}