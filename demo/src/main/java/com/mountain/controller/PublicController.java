package com.mountain.controller;

import com.mountain.common.R;
import com.mountain.entity.Merchant;
import com.mountain.service.MerchantService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;

/**
 * 公共API控制器（无需登录）
 */
@RestController
@RequestMapping("/api/public")
public class PublicController {

    @Autowired
    private MerchantService merchantService;

    /**
     * 查询附近商家
     */
    @GetMapping("/merchants/nearby")
    public R<List<Merchant>> getNearbyMerchants(
            @RequestParam Double latitude,
            @RequestParam Double longitude,
            @RequestParam(defaultValue = "5.0") Double distance,
            @RequestParam(required = false) Integer merchantType) {
        List<Merchant> merchants = merchantService.getNearbyMerchants(latitude, longitude, distance, merchantType);
        return R.success(merchants);
    }

    /**
     * 获取商家详情
     */
    @GetMapping("/merchants/{merchantId}")
    public R<Merchant> getMerchantDetail(@PathVariable Long merchantId) {
        Merchant merchant = merchantService.getById(merchantId);
        return R.success(merchant);
    }

    /**
     * 获取所有已审核通过的商家
     */
    @GetMapping("/merchants")
    public R<List<Merchant>> getAllMerchants(@RequestParam(required = false) Integer merchantType) {
        // 简化实现：返回所有已审核通过的商家
        List<Merchant> merchants = merchantService.getNearbyMerchants(0.0, 0.0, 999999.0, merchantType);
        return R.success(merchants);
    }
}





