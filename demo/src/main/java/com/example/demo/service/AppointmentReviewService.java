package com.example.demo.service;

import com.baomidou.mybatisplus.extension.service.IService;
import com.example.demo.dto.AppointmentReviewDTO;
import com.example.demo.entity.AppointmentReview;

import java.util.List;

/**
 * 预约评价服务接口
 */
public interface AppointmentReviewService extends IService<AppointmentReview> {

    /**
     * 创建评价
     *
     * @param reviewDTO 评价DTO
     * @param userId    用户ID
     * @return 评价ID
     */
    Long createReview(AppointmentReviewDTO reviewDTO, Long userId);

    /**
     * 根据用户ID查询评价列表
     *
     * @param userId 用户ID
     * @return 评价列表
     */
    List<AppointmentReview> getReviewsByUserId(Long userId);

    /**
     * 根据商家ID查询评价列表
     *
     * @param merchantId 商家ID
     * @return 评价列表
     */
    List<AppointmentReview> getReviewsByMerchantId(Long merchantId);

    /**
     * 根据预约ID查询评价
     *
     * @param appointmentId 预约ID
     * @return 评价信息
     */
    AppointmentReview getReviewByAppointmentId(Long appointmentId);

    /**
     * 商家回复评价
     *
     * @param reviewId     评价ID
     * @param replyContent 回复内容
     * @param merchantId   商家ID
     * @return 是否成功
     */
    Boolean replyReview(Long reviewId, String replyContent, Long merchantId);

    /**
     * 检查预约是否可以评价
     *
     * @param appointmentId 预约ID
     * @param userId        用户ID
     * @return 是否可以评价
     */
    Boolean checkCanReview(Long appointmentId, Long userId);
}


