package com.example.demo.common;

import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import org.springframework.util.StringUtils;

import java.util.HashMap;
import java.util.Map;

/**
 * 分页工具类
 */
public class PageUtil {

    /**
     * 默认页码
     */
    public static final long DEFAULT_CURRENT = 1;

    /**
     * 默认每页数量
     */
    public static final long DEFAULT_SIZE = 10;

    /**
     * 最大每页数量
     */
    public static final long MAX_SIZE = 100;

    /**
     * 创建分页对象
     * @param current 当前页码
     * @param size 每页数量
     * @return Page对象
     */
    public static <T> Page<T> createPage(Long current, Long size) {
        // 处理空值
        if (current == null || current <= 0) {
            current = DEFAULT_CURRENT;
        }
        if (size == null || size <= 0) {
            size = DEFAULT_SIZE;
        }
        // 限制最大页数
        if (size > MAX_SIZE) {
            size = MAX_SIZE;
        }
        return new Page<>(current, size);
    }

    /**
     * 构建分页参数
     * @param current 当前页码
     * @param size 每页数量
     * @return 分页参数Map
     */
    public static Map<String, Object> buildPageParam(Long current, Long size) {
        Map<String, Object> param = new HashMap<>();
        param.put("current", current == null || current <= 0 ? DEFAULT_CURRENT : current);
        param.put("size", size == null || size <= 0 ? DEFAULT_SIZE : size);
        return param;
    }

    /**
     * 转换为分页响应结果
     * @param page MyBatis Plus的Page对象
     * @return PageResult对象
     */
    public static <T> PageResult<T> toPageResult(Page<T> page) {
        if (page == null) {
            return new PageResult<>();
        }
        return new PageResult<>(
                page.getCurrent(),
                page.getSize(),
                page.getTotal(),
                page.getRecords()
        );
    }

    /**
     * 处理排序参数
     * @param sort 排序字段
     * @param order 排序方式（asc/desc）
     * @return 排序SQL片段
     */
    public static String handleOrderBy(String sort, String order) {
        if (!StringUtils.hasText(sort)) {
            return null;
        }
        StringBuilder orderBy = new StringBuilder();
        orderBy.append(sort);
        if (StringUtils.hasText(order) && "desc".equalsIgnoreCase(order)) {
            orderBy.append(" DESC");
        } else {
            orderBy.append(" ASC");
        }
        return orderBy.toString();
    }
}