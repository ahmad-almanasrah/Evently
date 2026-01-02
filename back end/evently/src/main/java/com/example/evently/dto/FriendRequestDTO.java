package com.example.evently.dto;

public record FriendRequestDTO(
        Long requestId,
        String senderName,
        String senderUsername,
        String senderPp
) {}