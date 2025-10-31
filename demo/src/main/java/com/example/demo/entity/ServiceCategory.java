package com.example.demo.entity;

import com.baomidou.mybatisplus.annotation.*;
import lombok.Data;

import java.io.Serializable;
import java.time.LocalDateTime;

/**
 * 服务类目表
 */
@Data
@TableName("service_category")
public class ServiceCategory implements Serializable {

    private static final long serialVersionUID = 1L;

    /**
     * 类目ID
     */
    @TableId(type = IdType.AUTO)
    private Long id;

    /**
     * 类目名称
     */
    private String categoryName;

    /**
     * 父类目ID
     */
    private Long parentId;

    /**
     * 排序权重
     */
    private Integer sort;

    /**
     * 状态：0-禁用，1-启用
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