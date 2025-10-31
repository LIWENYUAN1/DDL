package com.example.demo.controller;

import com.example.demo.common.R;
import com.example.demo.common.PageResult;
import com.example.demo.dto.PageDTO;
import com.example.demo.entity.Appointment;
import com.example.demo.entity.Merchant;
import com.example.demo.entity.SysUser;
import com.example.demo.service.MerchantService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;

/**
 * 商家控制器
 */
@RestController
@RequestMapping("/api/merchant")
public class MerchantController {

    @Autowired
    private MerchantService merchantService;

    /**
     * 获取商家信息
     */
    @GetMapping("/info")
    public R<Merchant> getMerchantInfo() {
        Long userId = getCurrentUserId();
        Merchant merchant = merchantService.getMerchantByUserId(userId);
        return R.success(merchant);
    }

    /**
     * 更新商家信息
     */
    @PutMapping("/info")
    public R<Boolean> updateMerchantInfo(@RequestBody Merchant merchant) {
        Long userId = getCurrentUserId();
        boolean result = merchantService.updateMerchantInfo(merchant, userId);
        return R.success(result);
    }

    /**
     * 获取商家预约列表
     */
    @GetMapping("/appointments")
    public R<PageResult<Appointment>> getMerchantAppointments(
            @Validated PageDTO pageDTO,
            @RequestParam(required = false) Integer status) {
        Long userId = getCurrentUserId();
        Merchant merchant = merchantService.getMerchantByUserId(userId);
        
        List<Appointment> appointments = merchantService.getMerchantAppointments(pageDTO, merchant.getId(), status);
        
        PageResult<Appointment> pageResult = new PageResult<>();
        pageResult.setRecords(appointments);
        pageResult.setCurrent((long) pageDTO.getPageNum());
        pageResult.setSize((long) pageDTO.getPageSize());
        pageResult.setTotal((long) appointments.size());
        pageResult.setPages((long) Math.ceil((double) appointments.size() / pageDTO.getPageSize()));
        
        return R.success(pageResult);
    }

    /**
     * 确认预约
     */
    @PostMapping("/appointments/{appointmentId}/confirm")
    public R<Boolean> confirmAppointment(@PathVariable Long appointmentId) {
        Long userId = getCurrentUserId();
        Merchant merchant = merchantService.getMerchantByUserId(userId);
        boolean result = merchantService.confirmAppointment(appointmentId, merchant.getId());
        return R.success(result);
    }

    /**
     * 完成预约
     */
    @PostMapping("/appointments/{appointmentId}/complete")
    public R<Boolean> completeAppointment(@PathVariable Long appointmentId) {
        Long userId = getCurrentUserId();
        Merchant merchant = merchantService.getMerchantByUserId(userId);
        boolean result = merchantService.completeAppointment(appointmentId, merchant.getId());
        return R.success(result);
    }

    /**
     * 拒绝预约
     */
    @PostMapping("/appointments/{appointmentId}/reject")
    public R<Boolean> rejectAppointment(
            @PathVariable Long appointmentId,
            @RequestParam String reason) {
        Long userId = getCurrentUserId();
        Merchant merchant = merchantService.getMerchantByUserId(userId);
        boolean result = merchantService.rejectAppointment(appointmentId, merchant.getId(), reason);
        return R.success(result);
    }

    /**
     * 获取商家营业统计
     */
    @GetMapping("/statistics")
    public R<Map<String, Object>> getMerchantStatistics() {
        Long userId = getCurrentUserId();
        Merchant merchant = merchantService.getMerchantByUserId(userId);
        Map<String, Object> statistics = merchantService.getMerchantStatistics(merchant.getId());
        return R.success(statistics);
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





