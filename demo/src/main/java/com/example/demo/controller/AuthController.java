package com.example.demo.controller;

import com.example.demo.common.R;
import com.example.demo.dto.LoginRequestDTO;
import com.example.demo.dto.RegisterRequestDTO;
import com.example.demo.dto.UserDTO;
import com.example.demo.service.SysUserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

/**
 * 用户认证控制器
 */
@RestController
@RequestMapping("/auth")
public class AuthController {

    @Autowired
    private SysUserService sysUserService;

    /**
     * 用户登录
     * @param loginRequestDTO 登录请求参数
     * @return 登录结果
     */
    @PostMapping("/login")
    public R<UserDTO> login(@Validated @RequestBody LoginRequestDTO loginRequestDTO) {
        UserDTO userDTO = sysUserService.login(loginRequestDTO);
        return R.success(userDTO);
    }

    /**
     * 用户注册
     * @param registerRequestDTO 注册请求参数
     * @return 注册结果
     */
    @PostMapping("/register")
    public R<Boolean> register(@Validated @RequestBody RegisterRequestDTO registerRequestDTO) {
        boolean result = sysUserService.register(registerRequestDTO);
        return R.success(result);
    }
    
    /**
     * 发送短信验证码
     * @param phone 手机号
     * @return 发送结果
     */
    @PostMapping("/sendCode")
    public R<Boolean> sendCode(String phone) {
        // TODO: 实现短信验证码发送逻辑
        return R.success(true);
    }
}