package com.example.evently.dto;

import com.example.evently.entity.User;
import jakarta.validation.constraints.NotBlank;

public record UpdatePasswordDTO(
        @NotBlank
        User user,
        @NotBlank
        String old,
        @NotBlank
        String newPassword
) {
}