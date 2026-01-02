package com.example.evently.repo;

import com.example.evently.entity.Event;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

public interface EventRepo extends JpaRepository<Event,Long> {


    @Query("SELECT CASE WHEN COUNT(e) > 0 THEN true ELSE false END FROM Event e " +
            "LEFT JOIN e.participants p " +
            "WHERE e.id = :eventId AND (e.owner.id = :userId OR p.id = :userId)")
    boolean isOwnerOrParticipant(@Param("eventId") Long eventId, @Param("userId") Long userId);

    @Query("SELECT e FROM Event e WHERE e.visible = true ORDER BY e.event_date DESC")
    Page<Event> findPublicEvents(Pageable pageable);

    List<Event> findAllByOwnerId(Long eventId);

    Integer countByOwnerId(Long eventId);
    @Query(value = "SELECT image_url FROM event_images WHERE event_id = :eventId", nativeQuery = true)
    List<String> findImagesByEventId(@Param("eventId") Long eventId);

    @Modifying
    @Transactional
    @Query(value = "INSERT INTO event_images (event_id, uploader_id, image_url) VALUES (:eventId, :uploaderId, :imageUrl)", nativeQuery = true)
    void saveEventImageRaw(@Param("eventId") Long eventId,
                           @Param("uploaderId") Long uploaderId,
                           @Param("imageUrl") String imageUrl);

    @Query("SELECT e.id FROM Event e JOIN e.participants p WHERE p.id = :userId")
    List<Long> findEventIdsByParticipantId(@Param("userId") Long userId);



}
