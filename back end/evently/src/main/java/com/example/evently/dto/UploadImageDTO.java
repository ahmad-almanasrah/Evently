package com.example.evently.dto;

import jakarta.validation.constraints.NotBlank;

public record UploadImageDTO(
        @NotBlank
        String imageUrl
) {
}
