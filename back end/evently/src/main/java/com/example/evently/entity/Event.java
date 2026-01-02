package com.example.evently.entity;

import jakarta.persistence.*;
import lombok.Data;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

@Entity
@Table(name = "events")
@Data
public class Event {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false)
    private String title;

    @Column(length = 100)
    private String description;

    @Column
    private LocalDateTime event_date;

    @Column
    private String cover_image; // This is just the main cover

    @Column
    private boolean visible;

    @Column
    private LocalDateTime created_at;

    @ManyToOne
    @JoinColumn(name = "owner_id")
    private User owner;

    // --- CHANGED SECTION ---
    // Replaced @ElementCollection with @OneToMany to store full Image objects
    @OneToMany(cascade = CascadeType.ALL, orphanRemoval = true)
    @JoinColumn(name = "event_id") // This tells JPA to look for 'event_id' in the event_images table
    private List<EventImage> images = new ArrayList<>();
    // -----------------------

    @ManyToMany
    @JoinTable(
            name = "event_participants",
            joinColumns = @JoinColumn(name = "event_id"),
            inverseJoinColumns = @JoinColumn(name = "user_id")
    )
    private List<User> participants = new ArrayList<>();
}