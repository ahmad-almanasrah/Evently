package com.example.evently.dto;

import jakarta.validation.constraints.NotBlank;
import org.springframework.web.multipart.MultipartFile;

public record UpdateProfilePictureDTO(
        @NotBlank
        Long Id,
        @NotBlank
        MultipartFile file
) {
}
