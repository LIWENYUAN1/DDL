package com.example.demo.dto;

import lombok.Data;

import java.io.Serializable;

/**
 * 用户信息DTO
 */
@Data
public class UserDTO implements Serializable {

    private static final long serialVersionUID = 1L;

    /**
     * 用户ID
     */
    private Long id;

    /**
     * 用户名
     */
    private String username;

    /**
     * 昵称
     */
    private String nickname;

    /**
     * 手机号
     */
    private String phone;

    /**
     * 用户类型：1-普通用户，2-商家，3-管理员
     */
    private Integer userType;

    /**
     * 头像
     */
    private String avatar;

    /**
     * 真实姓名（可选）
     */
    private String realName;

    /**
     * JWT令牌
     */
    private String token;
}