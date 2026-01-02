package com.example.evently.repo;

import com.example.evently.entity.EventImage;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;
import java.util.List;

@Repository
public interface ImagesRepo extends JpaRepository<EventImage, Long> {

    // 1. Find all images for a specific Event
    List<EventImage> findByEventId(Long eventId);

    // 2. Count pictures posted by a specific User
    // ✅ FIXED: Use 'countByUploaderId' because your entity has 'private Long uploaderId'
    Integer countByUploaderId(Long uploaderId);

    // In com.example.evently.repo.ImagesRepo

    // Logic: Fetch images where the event is in the list of events the user has joined
    @Query("SELECT i FROM EventImage i " +
            "WHERE i.eventId IN " +
            "(SELECT e.id FROM Event e JOIN e.participants p WHERE p.id = :userId) " +
            "ORDER BY i.uploadedAt DESC")
    Page<EventImage> findFeedImages(@Param("userId") Long userId, Pageable pageable);
}