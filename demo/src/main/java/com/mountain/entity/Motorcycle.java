package com.mountain.entity;

import com.baomidou.mybatisplus.annotation.*;
import lombok.Data;

import java.io.Serializable;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;

/**
 * 摩托车信息表
 */
@Data
@TableName("motorcycle")
public class Motorcycle implements Serializable {

    private static final long serialVersionUID = 1L;

    /**
     * 车辆ID
     */
    @TableId(type = IdType.AUTO)
    private Long id;

    /**
     * 关联owner_info表的id（车主）
     */
    private Long ownerId;

    /**
     * 车牌号
     */
    private String licensePlate;

    /**
     * 品牌
     */
    private String brand;

    /**
     * 车型
     */
    private String model;

    /**
     * 排量
     */
    private BigDecimal displacement;

    /**
     * 购买日期
     */
    private LocalDate purchaseTime;

    /**
     * 车辆识别码
     */
    private String vin;

    /**
     * 状态：0-已注销，1-正常使用
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