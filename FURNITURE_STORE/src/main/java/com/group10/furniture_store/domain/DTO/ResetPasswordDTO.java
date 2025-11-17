package com.group10.furniture_store.domain.DTO;

import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;
import lombok.Data;

@Data
public class ResetPasswordDTO {
    // Token để reset password (không validate vì có thể null)
    private String token;

    // Email không bắt buộc khi reset qua token
    @Email(message = "Email không hợp lệ")
    private String email;

    @NotBlank(message = "Mật khẩu mới không được bỏ trống")
    @Size(min = 6, message = "Mật khẩu phải có ít nhất 6 ký tự")
    private String newPassword;

    @NotBlank(message = "Mật khẩu xác nhận chưa khớp")
    private String confirmPassword;
}
