package com.mountain.common;

import com.mountain.exception.BusinessException;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.validation.BindException;
import org.springframework.validation.FieldError;
import org.springframework.web.bind.MethodArgumentNotValidException;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.ResponseStatus;
import org.springframework.web.bind.annotation.RestControllerAdvice;

import java.util.HashMap;
import java.util.Map;

/**
 * 全局异常处理器
 */
@Slf4j
@RestControllerAdvice
public class GlobalExceptionHandler {

    /**
     * 业务异常处理
     */
    @ExceptionHandler(BusinessException.class)
    @ResponseStatus(HttpStatus.OK)
    public R<?> handleBusinessException(BusinessException e) {
        log.error("业务异常: {}", e.getMessage());
        return R.error(e.getCode(), e.getMessage());
    }

    /**
     * 参数校验异常处理
     */
    @ExceptionHandler(MethodArgumentNotValidException.class)
    @ResponseStatus(HttpStatus.OK)
    public R<?> handleValidationException(MethodArgumentNotValidException e) {
        log.error("参数校验异常: {}", e.getMessage());
        Map<String, String> errors = new HashMap<>();
        e.getBindingResult().getAllErrors().forEach(error -> {
            String fieldName = ((FieldError) error).getField();
            String errorMessage = error.getDefaultMessage();
            errors.put(fieldName, errorMessage);
        });
        return R.error(ResultCode.VALIDATION_ERROR.getCode(), 
                      "参数校验失败: " + errors.toString());
    }

    /**
     * 绑定异常处理
     */
    @ExceptionHandler(BindException.class)
    @ResponseStatus(HttpStatus.OK)
    public R<?> handleBindException(BindException e) {
        log.error("绑定异常: {}", e.getMessage());
        Map<String, String> errors = new HashMap<>();
        e.getBindingResult().getAllErrors().forEach(error -> {
            String fieldName = ((FieldError) error).getField();
            String errorMessage = error.getDefaultMessage();
            errors.put(fieldName, errorMessage);
        });
        return R.error(ResultCode.VALIDATION_ERROR.getCode(), 
                      "参数绑定失败: " + errors.toString());
    }

    /**
     * 空指针异常处理
     */
    @ExceptionHandler(NullPointerException.class)
    @ResponseStatus(HttpStatus.OK)
    public R<?> handleNullPointerException(NullPointerException e) {
        log.error("空指针异常", e);
        e.printStackTrace();
        return R.error(ResultCode.SYSTEM_ERROR.getCode(), 
                      "系统错误: 空指针异常 - " + e.getMessage() + " at " + 
                      (e.getStackTrace().length > 0 ? e.getStackTrace()[0].toString() : "unknown"));
    }

    /**
     * 非法参数异常处理
     */
    @ExceptionHandler(IllegalArgumentException.class)
    @ResponseStatus(HttpStatus.OK)
    public R<?> handleIllegalArgumentException(IllegalArgumentException e) {
        log.error("非法参数异常: {}", e.getMessage(), e);
        return R.error(ResultCode.PARAM_ERROR.getCode(), 
                      "参数错误: " + e.getMessage());
    }

    /**
     * 运行时异常处理
     */
    @ExceptionHandler(RuntimeException.class)
    @ResponseStatus(HttpStatus.OK)
    public R<?> handleRuntimeException(RuntimeException e) {
        log.error("运行时异常", e);
        e.printStackTrace();
        
        // 获取详细的错误信息
        String detailMessage = e.getMessage();
        if (e.getCause() != null) {
            detailMessage += " | Cause: " + e.getCause().getMessage();
        }
        
        // 获取堆栈跟踪的第一行
        String stackTrace = "";
        if (e.getStackTrace().length > 0) {
            stackTrace = " at " + e.getStackTrace()[0].toString();
        }
        
        return R.error(ResultCode.SYSTEM_ERROR.getCode(), 
                      "系统错误: " + detailMessage + stackTrace);
    }

    /**
     * 通用异常处理
     */
    @ExceptionHandler(Exception.class)
    @ResponseStatus(HttpStatus.OK)
    public R<?> handleException(Exception e) {
        log.error("系统异常", e);
        e.printStackTrace();
        
        // 获取详细的错误信息
        String detailMessage = e.getClass().getSimpleName() + ": " + e.getMessage();
        if (e.getCause() != null) {
            detailMessage += " | Cause: " + e.getCause().getMessage();
        }
        
        // 获取堆栈跟踪的第一行
        String stackTrace = "";
        if (e.getStackTrace().length > 0) {
            stackTrace = " at " + e.getStackTrace()[0].toString();
        }
        
        return R.error(ResultCode.SYSTEM_ERROR.getCode(), 
                      "系统错误: " + detailMessage + stackTrace);
    }
}

