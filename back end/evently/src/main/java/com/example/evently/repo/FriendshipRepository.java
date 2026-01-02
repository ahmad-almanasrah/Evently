package com.example.evently.repo;

import com.example.evently.entity.Friendship;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface FriendshipRepository extends JpaRepository<Friendship, Long> {

    @Query("SELECT COUNT(f) FROM Friendship f WHERE (f.sender.id = :userId OR f.receiver.id = :userId) AND f.status = 'ACCEPTED'")
    long countAcceptedFriendsByUserId(@Param("userId") Long userId);

    // Find all accepted friendships for a user
    @Query("SELECT f FROM Friendship f WHERE (f.sender.id = :userId OR f.receiver.id = :userId) AND f.status = 'ACCEPTED'")
    List<Friendship> findAllAcceptedFriends(@Param("userId") Long userId);

    // Check if a request already exists to prevent duplicates
    Optional<Friendship> findBySenderIdAndReceiverId(Long senderId, Long receiverId);

    @Query("SELECT f FROM Friendship f WHERE f.receiver.id = :userId AND f.status = 'PENDING'")
    List<Friendship> findPendingRequestsForUser(@Param("userId") Long userId);
}