package com.example.demo.controller;

import com.example.demo.common.R;
import com.example.demo.dto.MotorcycleDTO;
import com.example.demo.entity.SysUser;
import com.example.demo.service.MotorcycleService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;

import java.util.List;

/**
 * 用户车辆管理
 */
@RestController
@RequestMapping("/user/motorcycles")
public class MotorcycleController {

    @Autowired
    private MotorcycleService motorcycleService;

    /**
     * 获取当前用户的车辆列表
     */
    @GetMapping
    public R<List<MotorcycleDTO>> list() {
        Long userId = getCurrentUserId();
        List<MotorcycleDTO> motorcycles = motorcycleService.listUserMotorcycles(userId);
        return R.success(motorcycles);
    }

    /**
     * 新增车辆
     */
    @PostMapping
    public R<MotorcycleDTO> create(@Validated @RequestBody MotorcycleDTO dto) {
        Long userId = getCurrentUserId();
        MotorcycleDTO result = motorcycleService.createMotorcycle(userId, dto);
        return R.success(result);
    }

    /**
     * 更新车辆
     */
    @PutMapping("/{id}")
    public R<Boolean> update(@PathVariable Long id, @Validated @RequestBody MotorcycleDTO dto) {
        Long userId = getCurrentUserId();
        boolean result = motorcycleService.updateMotorcycle(userId, id, dto);
        return R.success(result);
    }

    /**
     * 删除车辆
     */
    @DeleteMapping("/{id}")
    public R<Boolean> delete(@PathVariable Long id) {
        Long userId = getCurrentUserId();
        boolean result = motorcycleService.removeMotorcycle(userId, id);
        return R.success(result);
    }

    private Long getCurrentUserId() {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        SysUser user = (SysUser) authentication.getPrincipal();
        return user.getId();
    }
}
