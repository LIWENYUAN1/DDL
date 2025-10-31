package com.example.demo.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.example.demo.entity.Merchant;
import org.apache.ibatis.annotations.Mapper;

/**
 * 商家Mapper
 */
@Mapper
public interface MerchantMapper extends BaseMapper<Merchant> {

    /**
     * 根据用户ID查询商家
     * @param userId 用户ID
     * @return 商家信息
     */
    Merchant selectByUserId(Long userId);

    /**
     * 更新商家评分
     * @param merchantId 商家ID
     * @param avgScore 平均评分
     * @return 更新结果
     */
    int updateScore(Long merchantId, Double avgScore);
}