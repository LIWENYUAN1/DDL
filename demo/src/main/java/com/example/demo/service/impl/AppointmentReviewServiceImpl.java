package com.example.demo.service.impl;

import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.example.demo.dto.AppointmentReviewDTO;
import com.example.demo.entity.Appointment;
import com.example.demo.entity.AppointmentReview;
import com.example.demo.exception.BusinessException;
import com.example.demo.mapper.AppointmentMapper;
import com.example.demo.mapper.AppointmentReviewMapper;
import com.example.demo.common.ResultCode;
import com.example.demo.service.AppointmentReviewService;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.List;

/**
 * 预约评价服务实现类
 */
@Slf4j
@Service
public class AppointmentReviewServiceImpl extends ServiceImpl<AppointmentReviewMapper, AppointmentReview> implements AppointmentReviewService {

    @Autowired
    private AppointmentMapper appointmentMapper;

    @Autowired
    private AppointmentReviewMapper appointmentReviewMapper;

    @Override
    @Transactional(rollbackFor = Exception.class)
    public Long createReview(AppointmentReviewDTO reviewDTO, Long userId) {
        // 1. 检查预约是否存在
        Appointment appointment = appointmentMapper.selectById(reviewDTO.getAppointmentId());
        if (appointment == null) {
            throw new BusinessException(ResultCode.APPOINTMENT_NOT_EXIST);
        }

        // 2. 检查预约是否属于当前用户
        if (!appointment.getUserId().equals(userId)) {
            throw new BusinessException(ResultCode.NO_PERMISSION);
        }

        // 3. 检查预约状态是否为已完成
        if (appointment.getStatus() != 3) {
            throw new BusinessException(ResultCode.APPOINTMENT_NOT_COMPLETED);
        }

        // 4. 检查是否已经评价过
        AppointmentReview existingReview = appointmentReviewMapper.selectByAppointmentId(reviewDTO.getAppointmentId());
        if (existingReview != null) {
            throw new BusinessException(ResultCode.REVIEW_ALREADY_EXISTS);
        }

        // 5. 创建评价
        AppointmentReview review = new AppointmentReview();
        review.setAppointmentId(reviewDTO.getAppointmentId());
        review.setUserId(userId);
        review.setMerchantId(appointment.getMerchantId());
        review.setScore(reviewDTO.getScore());
        review.setServiceScore(reviewDTO.getServiceScore());
        review.setQualityScore(reviewDTO.getQualityScore());
        review.setAttitudeScore(reviewDTO.getAttitudeScore());
        review.setContent(reviewDTO.getContent());
        review.setImgUrls(reviewDTO.getImgUrls());
        review.setIsAnonymous(reviewDTO.getIsAnonymous() != null ? reviewDTO.getIsAnonymous() : 0);
        review.setStatus(1); // 默认显示
        review.setCreateTime(LocalDateTime.now());
        review.setUpdateTime(LocalDateTime.now());

        appointmentReviewMapper.insert(review);

        log.info("用户 {} 为预约 {} 创建了评价，评分：{}", userId, reviewDTO.getAppointmentId(), reviewDTO.getScore());

        return review.getId();
    }

    @Override
    public List<AppointmentReview> getReviewsByUserId(Long userId) {
        return appointmentReviewMapper.selectByUserId(userId);
    }

    @Override
    public List<AppointmentReview> getReviewsByMerchantId(Long merchantId) {
        return appointmentReviewMapper.selectByMerchantId(merchantId);
    }

    @Override
    public AppointmentReview getReviewByAppointmentId(Long appointmentId) {
        return appointmentReviewMapper.selectByAppointmentId(appointmentId);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public Boolean replyReview(Long reviewId, String replyContent, Long merchantId) {
        // 1. 检查评价是否存在
        AppointmentReview review = appointmentReviewMapper.selectById(reviewId);
        if (review == null) {
            throw new BusinessException(ResultCode.REVIEW_NOT_EXIST);
        }

        // 2. 检查评价是否属于该商家
        if (!review.getMerchantId().equals(merchantId)) {
            throw new BusinessException(ResultCode.NO_PERMISSION);
        }

        // 3. 更新回复内容
        review.setReplyContent(replyContent);
        review.setReplyTime(LocalDateTime.now());
        review.setUpdateTime(LocalDateTime.now());

        int result = appointmentReviewMapper.updateById(review);

        log.info("商家 {} 回复了评价 {}", merchantId, reviewId);

        return result > 0;
    }

    @Override
    public Boolean checkCanReview(Long appointmentId, Long userId) {
        // 1. 检查预约是否存在
        Appointment appointment = appointmentMapper.selectById(appointmentId);
        if (appointment == null) {
            return false;
        }

        // 2. 检查预约是否属于当前用户
        if (!appointment.getUserId().equals(userId)) {
            return false;
        }

        // 3. 检查预约状态是否为已完成
        if (appointment.getStatus() != 3) {
            return false;
        }

        // 4. 检查是否已经评价过
        AppointmentReview existingReview = appointmentReviewMapper.selectByAppointmentId(appointmentId);
        return existingReview == null;
    }
}


