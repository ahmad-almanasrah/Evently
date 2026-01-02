package com.example.evently.dto;

import java.time.LocalDateTime;
import java.util.List;

public record EventDetailsDTO(
        Long id,
        String title,
        String description,
        LocalDateTime eventDate,
        LocalDateTime createdDate, // For "Created 2 days ago" logic
        boolean isPublic,          // For the "Public" badge
        String creatorName,        // For "Created by John Doe"
        String creatorProfileImage,// For the CircleAvatar
        List<String> photos,       // For the Photo Grid
        int photoCount,            // For "Photos (124)"
        boolean isOwner            // Crucial: Tells Flutter to show Edit/Delete or Leave
) {}