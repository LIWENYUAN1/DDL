package com.example.demo.dto;

import lombok.Data;

import jakarta.validation.constraints.NotBlank;

/**
 * 登录请求DTO
 */
@Data
public class LoginRequestDTO {

    /**
     * 用户名
     */
    @NotBlank(message = "用户名不能为空")
    private String username;

    /**
     * 密码
     */
    @NotBlank(message = "密码不能为空")
    private String password;

    /**
     * 登录类型：1-普通用户，2-商家，3-管理员
     */
    private Integer userType = 1;
}