package com.example.evently.controller;

import com.example.evently.dto.*;
import com.example.evently.entity.Event;
import com.example.evently.entity.User;
import com.example.evently.repo.EventRepo;
import com.example.evently.repo.UserRepo;
import com.example.evently.service.UserService;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.util.List;
import java.util.Map;


@RestController
@RequestMapping("/home")
public class HomeController {
    private final UserService userService;
    private final UserRepo userRepo;
    private final EventRepo eventRepo;

    public HomeController(UserService userService, UserRepo userRepo, EventRepo eventRepo) {
        this.userService = userService;
        this.userRepo = userRepo;
        this.eventRepo = eventRepo;
    }

    @PostMapping("/friends/request/{receiverId}")
    public ResponseEntity<Map<String, String>> sendFriendRequest(@PathVariable Long receiverId, Authentication auth) {
        userService.sendFriendRequest(receiverId, auth.getName());
        return ResponseEntity.ok(Map.of("status", "success", "message", "Request sent"));
    }

    @PutMapping("/friends/respond/{requestId}")
    public ResponseEntity<Map<String, String>> respondToRequest(@PathVariable Long requestId, @RequestParam String action) {
        userService.respondToFriendRequest(requestId, action);
        return ResponseEntity.ok(Map.of("status", "success"));
    }

    @GetMapping("/users/search")
    public ResponseEntity<List<FriendDTO>> searchUsers(@RequestParam String query, Authentication auth) {
        return ResponseEntity.ok(userService.searchUsers(query, auth.getName()));
    }

    // ... inside HomeController ...

    @GetMapping("/GetJoinedEvents")
    public ResponseEntity<List<GetAllEventsDTO>> getJoinedEvents(Authentication auth) {
        // This calls the service we just made
        List<GetAllEventsDTO> events = userService.getJoinedEvents(auth.getName());
        return ResponseEntity.ok(events);
    }
    // ... inside HomeController ...

    // 1. INVITE FRIENDS ENDPOINT
    @PostMapping("/Event/{id}/invite")
    public ResponseEntity<Map<String, String>> inviteFriends(
            @PathVariable Long id,
            @RequestBody Map<String, List<Long>> requestBody, // Expects {"userIds": [1, 2, 3]}
            Authentication auth) {

        // Extract the list from the JSON body
        List<Long> userIds = requestBody.get("userIds");

        if (userIds == null || userIds.isEmpty()) {
            return ResponseEntity.badRequest().body(Map.of("status", "fail", "message", "No user IDs provided"));
        }

        userService.inviteFriendsToEvent(id, userIds);
        return ResponseEntity.ok(Map.of("status", "success", "message", "Friends invited successfully"));
    }

    // 2. JOIN VIA QR ENDPOINT
    @PostMapping("/JoinEvent/{id}")
    public ResponseEntity<Map<String, String>> joinEventQr(@PathVariable Long id, Authentication auth) {
        try {
            userService.joinEventViaQr(id, auth.getName());
            return ResponseEntity.ok(Map.of("status", "success", "message", "Joined event successfully!"));
        } catch (RuntimeException e) {
            // Return 400 if event doesn't exist or already joined
            return ResponseEntity.badRequest().body(Map.of("status", "fail", "message", e.getMessage()));
        }
    }

    @GetMapping("/friends/list")
    public ResponseEntity<List<FriendDTO>> getFriendsList(Authentication auth) {
        return ResponseEntity.ok(userService.getFriendsList(auth.getName()));
    }

    @GetMapping("/friends/pending")
    public ResponseEntity<List<FriendRequestDTO>> getPendingRequests(Authentication auth) {
        return ResponseEntity.ok(userService.getPendingRequests(auth.getName()));
    }

    @GetMapping("/profile")
    public ResponseEntity<ProfileDTO> getProfile(Authentication auth) {
        String email = auth.getName();
        ProfileDTO userProfile = userService.getUserProfile(email);
        return ResponseEntity.ok(userProfile);
    }

    @PostMapping("/Update/ProfilePicture")
    public ResponseEntity<String> updateProfilePicture(@RequestParam("file") MultipartFile file, Authentication auth) {
        String email = auth.getName();
        User user = userRepo.findByEmail(email)
                .orElseThrow(()->new UsernameNotFoundException("Username not found"));
        UpdateProfilePictureDTO dto = new UpdateProfilePictureDTO(user.getID(), file);
        userService.updateProfilePicture(dto);
    return ResponseEntity.ok("Successfully updated profile picture");

    }

    @PutMapping("/Update/Username")
    public Map<String,String> updateUsername(@RequestBody Map<String, String> request, Authentication auth) {
        String email = auth.getName();
        User user = userRepo.findByEmail(email)
                .orElseThrow(() -> new UsernameNotFoundException("Username not found"));
        user.setUsername(request.get("username"));
        try {
            userRepo.save(user);
            return Map.of("status","success");
        }
        catch (Exception e) {
            return Map.of("status","fail");
        }
    }

    @PutMapping("/Update/Email")
    public Map<String,String> updateEmail(@RequestBody Map<String, String> request, Authentication auth) {
        String currentEmail = auth.getName();
        String newEmail = request.get("email");

        User user = userRepo.findByEmail(currentEmail)
                .orElseThrow(() -> new UsernameNotFoundException("Username not found"));

        // Check if new email is already used by someone else
        if (userRepo.existsByEmail(newEmail) && !newEmail.equals(currentEmail)) {
            return Map.of("status", "fail", "message", "Email already exists");
        }

        user.setEmail(newEmail);
        userRepo.save(user);
        return Map.of("status","success");
    }


    @PutMapping("Update/Password")
    public Map<String,String> updatePassword( @RequestBody PasswordRequest request, Authentication auth) {
        String email = auth.getName();
        User user = userRepo.findByEmail(email)
                .orElseThrow(()->new UsernameNotFoundException("Username not found"));
        UpdatePasswordDTO dto = new UpdatePasswordDTO(user,request.old(),request.newPassword());
        boolean u = userService.updatePassword(dto);
        if(u==true){
            return Map.of("status","Success");
        }
        return Map.of("status","fail");

    }

    @PostMapping("/CreateEvent")
    public Map<String,String> createEvent(@RequestBody CreateEventDTO dto, Authentication auth){
        String email = auth.getName();

        User user = userRepo.findByEmail(email)
                .orElseThrow(()->new UsernameNotFoundException("Username not found"));
        Long id = userService.createEvent(dto,user);
    return  Map.of("status", "success", "ID", id.toString());
    }

    @PostMapping("/UploadImages/{id}")
    public Map<String, String> uploadImages(@PathVariable Long id, @RequestBody List<UploadImageDTO> dto, Authentication auth) {


        String email = auth.getName();

        User user = userRepo.findByEmail(email)
                .orElseThrow(()->new UsernameNotFoundException("Username not found"));
        Long oid = user.getID();
        userService.uploadImages(dto,id,oid);
        return Map.of("status", "success");
    }
    @GetMapping("/GetEvents")
    public ResponseEntity<List<GetAllEventsDTO>> getEvents(Authentication auth) {
        String email = auth.getName();

        User user = userRepo.findByEmail(email)
                .orElseThrow(()->new UsernameNotFoundException("Username not found"));
        Long id = user.getID();

        List<Event> myEvents = eventRepo.findAllByOwnerId(id);
        List<GetAllEventsDTO> response = myEvents.stream()
                .map(event -> new GetAllEventsDTO(
                        event.getId(),
                        event.getTitle(),
                        event.getDescription(),
                        event.getEvent_date(),
                        event.isVisible(),

//                        "http://192.168.1.14:8080/uploads/" + event.getCover_image()
                        "http://192.168.1.14:8080/uploads/11.jpg"
                ))
                .toList();

        return ResponseEntity.ok(response);
    }

    // Inside HomeController.java

    @GetMapping("/Event/{id}/details")
    public ResponseEntity<EventDetailsDTO> getEventDetails(@PathVariable Long id, Authentication auth) {
        // auth.getName() gets the email of the person currently holding the phone
        EventDetailsDTO response = userService.getEventDetails(id, auth.getName());

        return ResponseEntity.ok(response);
    }

    @GetMapping("/feed")
    public ResponseEntity<List<GetAllEventsDTO>> getPublicFeed(
            @RequestParam(defaultValue = "0") int page, // 0 = First page
            @RequestParam(defaultValue = "10") int size  // 5 posts per request
    ) {
        // 1. Create PageRequest (Just page number and size)
        // We don't need Sort.by() here because the @Query in Repo handles it.
        Pageable pageable = PageRequest.of(page, size);

        // 2. Fetch the page
        Page<Event> eventPage = eventRepo.findPublicEvents(pageable);

        // 3. Convert to DTO
        List<GetAllEventsDTO> response = eventPage.getContent().stream()
                .map(event -> new GetAllEventsDTO(
                        event.getId(),
                        event.getTitle(),
                        event.getDescription(),
                        event.getEvent_date(),
                        event.isVisible(),
                        // Using your hardcoded image for now as requested
                        "http://192.168.1.14:8080/uploads/11.jpg"
                ))
                .toList();

        return ResponseEntity.ok(response);
    }

    @GetMapping("/homee")
    String home(Authentication p){
    return "Hello World " + p.getName();
}
}

