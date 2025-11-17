package com.group10.furniture_store.domain.DTO;

import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotEmpty;

public class ForgotPasswordDTO {
    @NotEmpty(message = "Email cannot be empty")
    @Email(message = "Invalid email")
    private String email;

    public ForgotPasswordDTO() {
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }
}
