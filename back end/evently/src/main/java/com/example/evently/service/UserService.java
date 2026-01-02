package com.example.evently.service;

import com.example.evently.dto.*;
import com.example.evently.entity.User;
import org.springframework.security.core.Authentication;

import java.util.List;

public interface UserService {
    Authentication loginUser(LoginDTO dto);
    int createUser (CreateUserDTO dto);
    void sendUserOTP(SendOtpDTO dto);
    int verifyUserOTP(VerifyOtpDTO dto);
    boolean restUserPassword(RestPasswordDTO dto);
    ProfileDTO getUserProfile(String email);
    Long createEvent(CreateEventDTO dto, User user);
    void uploadImages(List<UploadImageDTO> dto, Long id, Long ownerId);
    void updateProfilePicture(UpdateProfilePictureDTO dto);
    boolean updatePassword(UpdatePasswordDTO dto);
    void joinEvent(Long eventId, String email);
    EventDetailsDTO getEventDetails(Long eventId, String currentUserEmail);
    void sendFriendRequest(Long receiverId, String senderEmail);
    void respondToFriendRequest(Long requestId, String action);
    List<FriendDTO> getFriendsList(String currentUserEmail);
    List<FriendRequestDTO> getPendingRequests(String currentUserEmail);
    List<FriendDTO> searchUsers(String query, String currentUserEmail);
    List<EventDetailsDTO> getMyJoinedEvents(String email);
    List<GetAllEventsDTO> getJoinedEvents(String email);
    void inviteFriendsToEvent(Long eventId, List<Long> friendIds);
    void joinEventViaQr(Long eventId, String userEmail);
}
