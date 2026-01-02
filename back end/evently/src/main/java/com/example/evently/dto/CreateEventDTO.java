package com.example.evently.dto;

import jakarta.validation.constraints.Future;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;

import java.time.LocalDateTime;

public record CreateEventDTO (

        @NotBlank
        String title,
        String description,
        @NotNull
        @Future
        LocalDateTime eventDate,
//        @NotBlank
//        String coverImage,
        boolean isPublic

){
}
