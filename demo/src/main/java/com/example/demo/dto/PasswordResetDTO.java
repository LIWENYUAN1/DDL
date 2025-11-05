package com.example.demo.dto;

import lombok.Data;

import javax.validation.constraints.NotBlank;
import java.io.Serializable;

/**
 * 重置密码请求参数
 */
@Data
public class PasswordResetDTO implements Serializable {

    private static final long serialVersionUID = 1L;

    @NotBlank(message = "请输入原密码")
    private String oldPassword;

    @NotBlank(message = "请输入新密码")
    private String newPassword;
}
