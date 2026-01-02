package com.example.evently.dto;

import java.time.LocalDateTime;

public record GetAllEventsDTO(
        Long id,
        String title,
        String description,
        LocalDateTime eventDate,
        boolean isPublic,
        String coverImageUrl

) {
}
