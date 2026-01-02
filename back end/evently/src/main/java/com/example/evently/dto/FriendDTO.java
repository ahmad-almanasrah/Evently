package com.example.evently.dto;

public record FriendDTO(
        Long id,
        String fullName,
        String username,
        String profilePicture // The URL to the image
) {}