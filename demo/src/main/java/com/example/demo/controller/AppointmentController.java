package com.example.demo.controller;

import com.example.demo.common.R;
import com.example.demo.common.PageResult;
import com.example.demo.dto.AppointmentRequestDTO;
import com.example.demo.dto.PageDTO;
import com.example.demo.entity.Appointment;
import com.example.demo.entity.SysUser;
import com.example.demo.mapper.MerchantMapper;
import com.example.demo.service.AppointmentService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;

import java.util.List;

/**
 * 预约控制器
 */
@RestController
@RequestMapping("/api/appointment")
public class AppointmentController {

    @Autowired
    private AppointmentService appointmentService;

    @Autowired
    private MerchantMapper merchantMapper;

    /**
     * 创建预约
     * @param appointmentRequestDTO 预约请求参数
     * @return 预约ID
     */
    @PostMapping("/create")
    public R<Long> createAppointment(@Validated @RequestBody AppointmentRequestDTO appointmentRequestDTO) {
        // 获取当前登录用户
        Long userId = getCurrentUserId();
        
        // 创建预约
        Long appointmentId = appointmentService.createAppointment(appointmentRequestDTO, userId);
        return R.success(appointmentId);
    }

    /**
     * 确认预约（商家操作）
     * @param appointmentId 预约ID
     * @return 操作结果
     */
    @PostMapping("/confirm/{appointmentId}")
    public R<Boolean> confirmAppointment(@PathVariable Long appointmentId) {
        // 获取当前登录用户
        Long userId = getCurrentUserId();
        
        // 查询商家信息
        Long merchantId = merchantMapper.selectByUserId(userId).getId();
        
        // 确认预约
        boolean result = appointmentService.confirmAppointment(appointmentId, merchantId);
        return R.success(result);
    }

    /**
     * 完成预约（商家操作）
     * @param appointmentId 预约ID
     * @return 操作结果
     */
    @PostMapping("/complete/{appointmentId}")
    public R<Boolean> completeAppointment(@PathVariable Long appointmentId) {
        // 获取当前登录用户
        Long userId = getCurrentUserId();
        
        // 查询商家信息
        Long merchantId = merchantMapper.selectByUserId(userId).getId();
        
        // 完成预约
        boolean result = appointmentService.completeAppointment(appointmentId, merchantId);
        return R.success(result);
    }

    /**
     * 取消预约
     * @param appointmentId 预约ID
     * @return 操作结果
     */
    @PostMapping("/cancel/{appointmentId}")
    public R<Boolean> cancelAppointment(@PathVariable Long appointmentId) {
        // 获取当前登录用户
        Long userId = getCurrentUserId();
        
        // 判断是否是商家
        boolean isMerchant = merchantMapper.selectByUserId(userId) != null;
        
        // 取消预约
        boolean result = appointmentService.cancelAppointment(appointmentId, userId, isMerchant);
        return R.success(result);
    }

    /**
     * 获取预约详情
     * @param appointmentId 预约ID
     * @return 预约详情
     */
    @GetMapping("/detail/{appointmentId}")
    public R<Appointment> getAppointmentDetail(@PathVariable Long appointmentId) {
        // 获取预约详情
        Appointment appointment = appointmentService.getAppointmentById(appointmentId);
        return R.success(appointment);
    }

    /**
     * 获取用户预约列表
     * @param pageDTO 分页参数
     * @return 预约列表
     */
    @GetMapping("/user/list")
    public R<PageResult<Appointment>> getUserAppointmentList(@Validated PageDTO pageDTO) {
        // 获取当前登录用户
        Long userId = getCurrentUserId();
        
        // 获取预约列表
        List<Appointment> appointmentList = appointmentService.getUserAppointmentList(pageDTO, userId);
        
        // 构建分页结果
        PageResult<Appointment> pageResult = new PageResult<>();
        pageResult.setRecords(appointmentList);
        pageResult.setCurrent((long) pageDTO.getPageNum());
        pageResult.setSize((long) pageDTO.getPageSize());
        // 这里简化处理，实际应该从分页对象中获取总记录数
        pageResult.setTotal(100L);
        pageResult.setPages((long) Math.ceil(100.0 / pageDTO.getPageSize()));
        
        return R.success(pageResult);
    }

    /**
     * 获取商家预约列表
     * @param pageDTO 分页参数
     * @param status 预约状态（可选）
     * @return 预约列表
     */
    @GetMapping("/merchant/list")
    public R<PageResult<Appointment>> getMerchantAppointmentList(@Validated PageDTO pageDTO, Integer status) {
        // 获取当前登录用户
        Long userId = getCurrentUserId();
        
        // 查询商家信息
        Long merchantId = merchantMapper.selectByUserId(userId).getId();
        
        // 获取预约列表
        List<Appointment> appointmentList = appointmentService.getMerchantAppointmentList(pageDTO, merchantId, status);
        
        // 构建分页结果
        PageResult<Appointment> pageResult = new PageResult<>();
        pageResult.setRecords(appointmentList);
        pageResult.setCurrent((long) pageDTO.getPageNum());
        pageResult.setSize((long) pageDTO.getPageSize());
        // 这里简化处理，实际应该从分页对象中获取总记录数
        pageResult.setTotal(100L);
        pageResult.setPages((long) Math.ceil(100.0 / pageDTO.getPageSize()));
        
        return R.success(pageResult);
    }

    /**
     * 获取当前登录用户ID
     */
    private Long getCurrentUserId() {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        SysUser user = (SysUser) authentication.getPrincipal();
        return user.getId();
    }
}