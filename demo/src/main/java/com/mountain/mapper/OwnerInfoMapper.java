package com.mountain.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.mountain.entity.OwnerInfo;
import org.apache.ibatis.annotations.Mapper;

/**
 * 车主信息Mapper
 */
@Mapper
public interface OwnerInfoMapper extends BaseMapper<OwnerInfo> {

    /**
     * 根据用户ID查询车主信息
     * @param userId 用户ID
     * @return 车主信息
     */
    OwnerInfo selectByUserId(Long userId);
}