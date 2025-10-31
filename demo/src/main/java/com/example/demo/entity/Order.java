package com.example.demo.entity;

import com.baomidou.mybatisplus.annotation.*;
import lombok.Data;

import java.io.Serializable;
import java.math.BigDecimal;
import java.time.LocalDateTime;

/**
 * 订单表
 */
@Data
@TableName("orders")
public class Order implements Serializable {

    private static final long serialVersionUID = 1L;

    /**
     * 订单ID
     */
    @TableId(type = IdType.AUTO)
    private Long id;

    /**
     * 订单号
     */
    private String orderNo;

    /**
     * 关联预约ID
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
     * 订单金额
     */
    private BigDecimal totalAmount;

    /**
     * 实付金额
     */
    private BigDecimal actualAmount;

    /**
     * 优惠金额
     */
    private BigDecimal discountAmount;

    /**
     * 支付方式：1-微信支付，2-支付宝支付，3-现金支付
     */
    private Integer payType;

    /**
     * 支付状态：0-未支付，1-已支付，2-支付失败
     */
    private Integer payStatus;

    /**
     * 支付时间
     */
    private LocalDateTime payTime;

    /**
     * 订单状态：0-待支付，1-进行中，2-已完成，3-已取消，4-已退款
     */
    private Integer status;

    /**
     * 备注
     */
    private String remark;

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