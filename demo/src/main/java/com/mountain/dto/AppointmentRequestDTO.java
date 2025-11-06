package com.mountain.dto;

import lombok.Data;

import jakarta.validation.constraints.NotNull;
import java.time.LocalDateTime;
import java.util.List;

/**
 * 预约请求DTO
 */
@Data
public class AppointmentRequestDTO {

    /**
     * 商家ID
     */
    @NotNull(message = "商家ID不能为空")
    private Long merchantId;

    /**
     * 车辆ID（可选，如果没有则使用车辆型号和车牌号创建）
     */
    private Long motorcycleId;

    /**
     * 车辆型号（motorcycleId为空时必填）
     */
    private String motorcycleModel;

    /**
     * 车牌号码（motorcycleId为空时必填）
     */
    private String licensePlate;

    /**
     * 联系电话
     */
    private String contactPhone;

    /**
     * 问题描述
     */
    private String description;

    /**
     * 预约服务时间
     */
    @NotNull(message = "预约时间不能为空")
    private String appointmentTime;

    /**
     * 服务项目ID
     */
    @NotNull(message = "服务项目ID不能为空")
    private Long serviceItemId;

    /**
     * 预约类型：1-立即服务，2-预约服务
     */
    private Integer appointmentType = 2;

    /**
     * 服务方式：1-到店服务，2-上门服务
     */
    private Integer serviceType = 1;

    /**
     * 服务地址
     */
    private String serviceAddress;

    /**
     * 备注
     */
    private String remark;

}