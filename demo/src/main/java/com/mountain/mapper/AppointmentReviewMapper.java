package com.mountain.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.mountain.entity.AppointmentReview;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

/**
 * 预约评价Mapper
 */
@Mapper
public interface AppointmentReviewMapper extends BaseMapper<AppointmentReview> {

    /**
     * 根据用户ID查询评价列表
     *
     * @param userId 用户ID
     * @return 评价列表
     */
    List<AppointmentReview> selectByUserId(@Param("userId") Long userId);

    /**
     * 根据商家ID查询评价列表
     *
     * @param merchantId 商家ID
     * @return 评价列表
     */
    List<AppointmentReview> selectByMerchantId(@Param("merchantId") Long merchantId);

    /**
     * 根据预约ID查询评价
     *
     * @param appointmentId 预约ID
     * @return 评价信息
     */
    AppointmentReview selectByAppointmentId(@Param("appointmentId") Long appointmentId);

    /**
     * 查询商家的平均评分
     *
     * @param merchantId 商家ID
     * @return 平均评分
     */
    Double selectAvgScoreByMerchantId(@Param("merchantId") Long merchantId);
}


