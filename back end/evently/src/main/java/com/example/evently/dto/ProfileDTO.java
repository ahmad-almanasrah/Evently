package com.example.evently.dto;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;

public record ProfileDTO(
        @NotBlank
        String pictureURL,
        @NotBlank
        String name,
        @NotBlank
        String userName,
        @NotBlank
        int friendsCount,
        @NotNull
        int galleriesCount,
        @NotBlank
        int pictureCount
) {
}
