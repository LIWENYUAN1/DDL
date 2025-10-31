package com.example.demo.entity;

import com.baomidou.mybatisplus.annotation.*;
import lombok.Data;

import java.io.Serializable;
import java.math.BigDecimal;
import java.time.LocalDateTime;

/**
 * 车主信息表
 */
@Data
@TableName("owner_info")
public class OwnerInfo implements Serializable {

    private static final long serialVersionUID = 1L;

    /**
     * 主键ID
     */
    @TableId(type = IdType.AUTO)
    private Long id;

    /**
     * 关联sys_user表的id
     */
    private Long userId;

    /**
     * 身份证号
     */
    private String idCard;

    /**
     * 常用地址
     */
    private String address;

    /**
     * 常用地址纬度
     */
    private BigDecimal latitude;

    /**
     * 常用地址经度
     */
    private BigDecimal longitude;

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