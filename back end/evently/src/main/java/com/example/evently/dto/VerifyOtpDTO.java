package com.example.evently.dto;

import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;

public record VerifyOtpDTO(
        @NotBlank
        @Email
        String email,
        @NotBlank
        String otp
) {
}
