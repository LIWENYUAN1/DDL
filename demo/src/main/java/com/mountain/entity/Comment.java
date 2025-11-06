package com.mountain.entity;

import com.baomidou.mybatisplus.annotation.*;
import lombok.Data;

import java.io.Serializable;
import java.time.LocalDateTime;

/**
 * 评论表
 */
@Data
@TableName("comment")
public class Comment implements Serializable {

    private static final long serialVersionUID = 1L;

    /**
     * 评论ID
     */
    @TableId(type = IdType.AUTO)
    private Long id;

    /**
     * 订单ID
     */
    private Long orderId;

    /**
     * 用户ID
     */
    private Long userId;

    /**
     * 商家ID
     */
    private Long merchantId;

    /**
     * 评分：1-5星
     */
    private Integer score;

    /**
     * 评论内容
     */
    private String content;

    /**
     * 图片URL，多个用逗号分隔
     */
    private String imageUrls;

    /**
     * 商家回复
     */
    private String replyContent;

    /**
     * 回复时间
     */
    private LocalDateTime replyTime;

    /**
     * 创建时间
     */
    @TableField(fill = FieldFill.INSERT)
    private LocalDateTime createTime;
}