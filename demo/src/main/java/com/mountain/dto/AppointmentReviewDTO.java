package com.mountain.dto;

import lombok.Data;

import jakarta.validation.constraints.Max;
import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotNull;

/**
 * 预约评价DTO
 */
@Data
public class AppointmentReviewDTO {

    /**
     * 预约ID
     */
    @NotNull(message = "预约ID不能为空")
    private Long appointmentId;

    /**
     * 综合评分（1-5分）
     */
    @NotNull(message = "评分不能为空")
    @Min(value = 1, message = "评分最低1分")
    @Max(value = 5, message = "评分最高5分")
    private Integer score;

    /**
     * 服务评分（1-5分）
     */
    @Min(value = 1, message = "服务评分最低1分")
    @Max(value = 5, message = "服务评分最高5分")
    private Integer serviceScore;

    /**
     * 质量评分（1-5分）
     */
    @Min(value = 1, message = "质量评分最低1分")
    @Max(value = 5, message = "质量评分最高5分")
    private Integer qualityScore;

    /**
     * 态度评分（1-5分）
     */
    @Min(value = 1, message = "态度评分最低1分")
    @Max(value = 5, message = "态度评分最高5分")
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
     * 是否匿名：0-否，1-是
     */
    private Integer isAnonymous;
}

