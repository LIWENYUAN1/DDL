package com.mountain.entity;

import com.baomidou.mybatisplus.annotation.*;
import lombok.Data;

import java.io.Serializable;
import java.math.BigDecimal;
import java.time.LocalDateTime;

/**
 * 预约信息表
 */
@Data
@TableName("appointment")
public class Appointment implements Serializable {

    private static final long serialVersionUID = 1L;

    /**
     * 预约ID
     */
    @TableId(type = IdType.AUTO)
    private Long id;

    /**
     * 预约单号
     */
    private String orderNo;

    /**
     * 用户ID
     */
    private Long userId;

    /**
     * 商家ID
     */
    private Long merchantId;

    /**
     * 车辆ID
     */
    private Long motorcycleId;

    /**
     * 预约服务时间
     */
    private LocalDateTime appointmentTime;

    /**
     * 预约类型：1-立即服务，2-预约服务
     */
    private Integer appointmentType;

    /**
     * 服务方式：1-到店服务，2-上门服务
     */
    private Integer serviceType;

    /**
     * 服务地址
     */
    private String serviceAddress;

    /**
     * 联系电话
     */
    private String contactPhone;

    /**
     * 问题描述
     */
    private String description;

    /**
     * 备注
     */
    private String remark;

    /**
     * 预约状态：0-待确认，1-已确认，2-已完成，3-已取消，4-已违约
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

    // ===== 以下为非数据库字段，用于查询时关联数据 =====

    /**
     * 商家名称（非数据库字段）
     */
    @TableField(exist = false)
    private String merchantName;

    /**
     * 服务项目名称（非数据库字段）
     */
    @TableField(exist = false)
    private String serviceItemName;

    /**
     * 用户名称（非数据库字段）
     */
    @TableField(exist = false)
    private String userName;

    /**
     * 车辆品牌（非数据库字段）
     */
    @TableField(exist = false)
    private String motorcycleBrand;

    /**
     * 车辆型号（非数据库字段）
     */
    @TableField(exist = false)
    private String motorcycleModel;

    /**
     * 车牌号（非数据库字段）
     */
    @TableField(exist = false)
    private String licensePlate;
}