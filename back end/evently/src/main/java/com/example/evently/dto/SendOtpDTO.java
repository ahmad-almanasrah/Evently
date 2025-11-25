package com.example.evently.dto;

import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;

public record SendOtpDTO(
        @NotBlank
        @Email
        String email
) {
}
