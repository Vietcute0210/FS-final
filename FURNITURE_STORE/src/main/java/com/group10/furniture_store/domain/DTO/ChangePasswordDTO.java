package com.group10.furniture_store.domain.DTO;

import jakarta.validation.constraints.Size;
import lombok.Builder;
import lombok.Data;

@Data
@Builder
public class ChangePasswordDTO {
    private Long userId;
    private String oldPassword;

    @Size(min = 6, message = "Mật khẩu mới phải có tối thiểu 6 ký tự")
    private String newPassword;

}
