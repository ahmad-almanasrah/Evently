package com.example.evently.entity;

import jakarta.persistence.*;
import lombok.Data;
import java.time.LocalDateTime;

@Entity
@Table(name = "event_images")
@Data
public class EventImage {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    // Just the ID. No @ManyToOne, no fetching the Event object.
    @Column(name = "event_id", nullable = false)
    private Long eventId;

    // Just the ID. No fetching the User object.
    @Column(name = "uploader_id", nullable = false)
    private Long uploaderId;

    @Column(name = "image_url", nullable = false)
    private String imageUrl;

    @Column(name = "uploaded_at")
    private LocalDateTime uploadedAt = LocalDateTime.now();
}