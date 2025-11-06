package com.mountain.controller;

import com.mountain.common.R;
import com.mountain.dto.AppointmentReviewDTO;
import com.mountain.entity.AppointmentReview;
import com.mountain.entity.SysUser;
import com.mountain.service.AppointmentReviewService;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * 预约评价控制器
 */
@Slf4j
@RestController
@RequestMapping("/api/review")
public class AppointmentReviewController {

    @Autowired
    private AppointmentReviewService appointmentReviewService;

    /**
     * 创建评价
     */
    @PostMapping("/create")
    public R<Map<String, Object>> createReview(
            @Validated @RequestBody AppointmentReviewDTO reviewDTO) {
        Long userId = getCurrentUserId();
        log.info("用户 {} 创建评价，预约ID：{}", userId, reviewDTO.getAppointmentId());

        Long reviewId = appointmentReviewService.createReview(reviewDTO, userId);

        Map<String, Object> result = new HashMap<>();
        result.put("reviewId", reviewId);
        
        return R.success(result, "评价成功");
    }

    /**
     * 检查预约是否可以评价
     */
    @GetMapping("/check-can-review/{appointmentId}")
    public R<Map<String, Object>> checkCanReview(@PathVariable Long appointmentId) {
        Long userId = getCurrentUserId();

        Boolean canReview = appointmentReviewService.checkCanReview(appointmentId, userId);

        Map<String, Object> result = new HashMap<>();
        result.put("canReview", canReview);

        return R.success(result);
    }

    /**
     * 根据预约ID获取评价
     */
    @GetMapping("/by-appointment/{appointmentId}")
    public R<AppointmentReview> getReviewByAppointmentId(@PathVariable Long appointmentId) {
        AppointmentReview review = appointmentReviewService.getReviewByAppointmentId(appointmentId);
        return R.success(review);
    }

    /**
     * 获取用户的评价列表
     */
    @GetMapping("/user/list")
    public R<List<AppointmentReview>> getUserReviews() {
        Long userId = getCurrentUserId();
        List<AppointmentReview> reviews = appointmentReviewService.getReviewsByUserId(userId);
        return R.success(reviews);
    }

    /**
     * 获取商家的评价列表
     */
    @GetMapping("/merchant/list")
    public R<String> getMerchantReviews() {
        Long userId = getCurrentUserId();
        // TODO: 需要根据userId获取merchantId
        // 这里暂时返回空列表，实际使用时需要完善
        return R.success("功能开发中");
    }

    /**
     * 商家回复评价
     */
    @PostMapping("/reply/{reviewId}")
    public R<String> replyReview(
            @PathVariable Long reviewId,
            @RequestParam String replyContent) {
        Long userId = getCurrentUserId();
        // TODO: 需要根据userId获取merchantId
        // 这里暂时返回提示，实际使用时需要完善
        return R.success("功能开发中");
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

