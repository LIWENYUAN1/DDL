package com.mountain.entity;

import com.baomidou.mybatisplus.annotation.*;
import lombok.Data;

import java.io.Serializable;
import java.math.BigDecimal;
import java.time.LocalDateTime;

/**
 * 预约服务项目关联表
 */
@Data
@TableName("appointment_service_item")
public class AppointmentServiceItem implements Serializable {

    private static final long serialVersionUID = 1L;

    /**
     * 主键ID
     */
    @TableId(type = IdType.AUTO)
    private Long id;

    /**
     * 预约ID
     */
    private Long appointmentId;

    /**
     * 服务项目ID
     */
    private Long serviceItemId;

    /**
     * 服务价格
     */
    private BigDecimal servicePrice;

    /**
     * 数量
     */
    private Integer quantity;

    /**
     * 创建时间
     */
    @TableField(fill = FieldFill.INSERT)
    private LocalDateTime createTime;
}