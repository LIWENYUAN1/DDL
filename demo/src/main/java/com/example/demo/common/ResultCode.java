package com.example.demo.common;

/**
 * 响应码枚举类
 */
public enum ResultCode {
    
    SUCCESS(200, "操作成功"),
    ERROR(500, "操作失败"),
    UNAUTHORIZED(401, "未授权"),
    FORBIDDEN(403, "禁止访问"),
    NOT_FOUND(404, "请求不存在"),
    INTERNAL_SERVER_ERROR(500, "服务器内部错误"),
    
    /**
     * 系统错误
     */
    SYSTEM_ERROR(5001, "系统错误"),
    PARAM_ERROR(400, "参数错误"),
    VALIDATION_ERROR(400, "验证失败"),
    USERNAME_OR_PASSWORD_ERROR(400, "用户名或密码错误"),
    USER_ACCOUNT_DISABLED(400, "账号已被禁用"),
    USERNAME_ALREADY_EXISTS(400, "用户名已存在"),
    PHONE_ALREADY_EXISTS(400, "手机号已存在"),
    PASSWORD_CONFIRM_ERROR(400, "两次输入的密码不一致"),
    USER_TYPE_ERROR(400, "用户类型错误"),
    USER_NOT_EXIST(404, "用户不存在"),
    OLD_PASSWORD_ERROR(400, "原密码错误"),
    MERCHANT_NOT_EXIST(404, "商家不存在"),
    MOTORCYCLE_NOT_EXIST(404, "车辆不存在"),
    LICENSE_PLATE_ALREADY_EXISTS(400, "车牌号已存在"),
    VIN_ALREADY_EXISTS(400, "车辆识别码已存在"),
    APPOINTMENT_NOT_EXIST(404, "预约不存在"),
    APPOINTMENT_STATUS_ERROR(400, "预约状态错误"),
    APPOINTMENT_NOT_COMPLETED(400, "预约未完成，无法评价"),
    REVIEW_ALREADY_EXISTS(400, "该预约已评价"),
    REVIEW_NOT_EXIST(404, "评价不存在"),
    NO_PERMISSION(403, "无权限操作"),
    PERMISSION_DENIED(403, "权限不足");
    
    private final int code;
    private final String msg;
    
    ResultCode(int code, String msg) {
        this.code = code;
        this.msg = msg;
    }
    
    public int getCode() {
        return code;
    }
    
    public String getMsg() {
        return msg;
    }
}