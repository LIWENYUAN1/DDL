package com.example.demo.dto;

import com.fasterxml.jackson.annotation.JsonFormat;
import lombok.Data;

import javax.validation.constraints.NotBlank;

import java.io.Serializable;
import java.math.BigDecimal;
import java.time.LocalDate;

/**
 * 用户车辆信息传输对象
 */
@Data
public class MotorcycleDTO implements Serializable {

    private static final long serialVersionUID = 1L;

    /**
     * 车辆ID
     */
    private Long id;

    /**
     * 品牌
     */
    @NotBlank(message = "请输入车辆品牌")
    private String brand;

    /**
     * 车型
     */
    @NotBlank(message = "请输入车辆车型")
    private String model;

    /**
     * 车牌号
     */
    private String licensePlate;

    /**
     * 排量
     */
    private BigDecimal displacement;

    /**
     * 购买日期
     */
    @JsonFormat(pattern = "yyyy-MM-dd")
    private LocalDate purchaseDate;

    /**
     * 车辆识别码
     */
    private String vin;

    /**
     * 状态：0-已注销，1-正常使用
     */
    private Integer status;
}
