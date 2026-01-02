    package com.example.evently.service;

    import com.example.evently.dto.*;
    import com.example.evently.entity.Event;
    import com.example.evently.entity.EventImage;
    import com.example.evently.entity.Friendship;
    import com.example.evently.entity.User;
    import com.example.evently.mapper.UserMapper;
    import com.example.evently.repo.EventRepo;
    import com.example.evently.repo.FriendshipRepository;
    import com.example.evently.repo.ImagesRepo;
    import com.example.evently.repo.UserRepo;
    import org.springframework.beans.factory.annotation.Value;
    import java.nio.file.Files;

    import org.springframework.data.domain.Page;
    import org.springframework.data.domain.PageRequest;
    import org.springframework.data.domain.Pageable;
    import org.springframework.mail.SimpleMailMessage;
    import org.springframework.mail.javamail.JavaMailSender;
    import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
    import org.springframework.security.core.Authentication;
    import org.springframework.security.core.authority.SimpleGrantedAuthority;
    import org.springframework.security.core.userdetails.UsernameNotFoundException;
    import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
    import org.springframework.stereotype.Service;
    import org.springframework.transaction.annotation.Transactional;
    import org.springframework.web.multipart.MultipartFile;

    import javax.imageio.ImageIO;
    import javax.swing.text.html.parser.Entity;
    import java.awt.*;
    import java.awt.image.BufferedImage;
    import java.io.File;
    import java.io.IOException;
    import java.nio.file.Path;
    import java.nio.file.Paths;
    import java.util.ArrayList;
    import java.util.List;

    @Service
    public class UserServiceImpl implements UserService {


        private final EventRepo eventRepo;
        private final ImagesRepo imagesRepo;
        @Value("${app.base-url}")
        private String baseUrl;

        private final UserMapper userMapper;
        private String OTP = "";
        private Long expiration;


        private final UserRepo userRepo;
        private final BCryptPasswordEncoder passwordEncoder;
        private final JavaMailSender javaMailSender;
        private final FriendshipRepository friendshipRepo;

        public UserServiceImpl(UserRepo userRepo, BCryptPasswordEncoder passwordEncoder, JavaMailSender javaMailSender, UserMapper userMapper, EventRepo eventRepo, ImagesRepo imagesRepo, FriendshipRepository friendshipRepo) {
            this.userRepo = userRepo;
            this.passwordEncoder = passwordEncoder;
            this.javaMailSender = javaMailSender;
            this.userMapper = userMapper;
            this.eventRepo = eventRepo;
            this.imagesRepo = imagesRepo;
            this.friendshipRepo = friendshipRepo;
        }

        @Override
        @Transactional
        public Authentication loginUser(LoginDTO dto) {
            String email = dto.email().toLowerCase().trim();

            var user = userRepo.findByEmail(email)
                    .orElseThrow(() -> new RuntimeException("Email not found"));

            if (!passwordEncoder.matches(dto.password(), user.getPassword())) {
                throw new RuntimeException("Invalid password");
            }

            // Create Authentication object to pass to TokenService
            return new UsernamePasswordAuthenticationToken(
                    user.getEmail(), // or email if you prefer
                    null,
                    List.of(new SimpleGrantedAuthority("read"))
            );
        }

        @Override
        @Transactional
        public int createUser(CreateUserDTO dto) {
            String email = dto.email().toLowerCase().trim();
            String password = dto.password();
            String username = dto.username();
            String fullName = dto.fullName();

            if (userRepo.existsByEmail(email)) {
                return 2; // Email already exists
            }
            if (userRepo.existsByUsername(username)) {
                return 3; // Username already exists
            }

            User user = new User();
            user.setFullName(fullName);
            user.setEmail(email);
            user.setPassword(passwordEncoder.encode(password));
            user.setUsername(username);
            userRepo.save(user);

            return 1; // Success
        }


        @Override
        public void sendUserOTP(SendOtpDTO dto) {
            String email = dto.email().toLowerCase().trim();
            if (userRepo.existsByEmail(email)) {
                String otp = otpGenerator();
                OTP = otp;
                expiration = System.currentTimeMillis() + 5 * 60 * 1000;
                sendEmail(email, otp);
            }
        }

        @Override
        public int verifyUserOTP(VerifyOtpDTO dto) {
            // Check if OTP exists
            if (OTP == null) return 1; // no OTP sent

            // Check if expired
            if (System.currentTimeMillis() > expiration) {
                OTP = null;
                return 2; // expired
            }

            // Check if OTP matches
            if (!OTP.equals(dto.otp().trim())) return 3; // wrong OTP

            // Success
            OTP = null; // clear after verification
            return 0;   // success
        }

        @Override
        public boolean restUserPassword(RestPasswordDTO dto) {
            String email = dto.email().toLowerCase().trim();
            if (userRepo.existsByEmail(email)) {
                User user = userRepo.findByEmail(email)
                        .orElseThrow(() -> new RuntimeException("Email not found"));
                String password = passwordEncoder.encode(dto.newPassword());
                user.setPassword(password);
                userRepo.save(user);
                return true;
            }
            return false;
        }

        // Inside UserService.java

        @Override
        public void joinEvent(Long eventId, String email) {
            // 1. Find the User
            User user = userRepo.findByEmail(email)
                    .orElseThrow(() -> new UsernameNotFoundException("User not found"));

            // 2. Find the Event
            Event event = eventRepo.findById(eventId)
                    .orElseThrow(() -> new RuntimeException("Event not found"));

            // 3. Add User to Event (Avoid duplicates)
            if (!event.getParticipants().contains(user)) {
                event.getParticipants().add(user);
                eventRepo.save(event); // This saves the relationship
            }
        }

        @Override
        public ProfileDTO getUserProfile(String email) {
            email = email.toLowerCase().trim();
            User user = userRepo.findByEmail(email)
                    .orElseThrow(() -> new RuntimeException("Email not found"));
            String fileName = user.getID() + ".jpg";
            Path imagePath = Paths.get("uploads/" + fileName);
            String relativePath;
            if (imagePath.toFile().exists()) {
                relativePath = "uploads/" + fileName;
            } else {
                relativePath = "uploads/default.jpg";
            }
            String finalUrl = baseUrl + "/" + relativePath;
            Integer events = eventRepo.countByOwnerId(user.getID());
            Integer images = imagesRepo.countByUploaderId(user.getID());
            Long friends = friendshipRepo.countAcceptedFriendsByUserId(user.getID());
            return userMapper.toDto(user, friends.intValue(), events.intValue(), images.intValue(), finalUrl);
        }

        // ... inside UserServiceImpl class ...

        @Override
        public List<GetAllEventsDTO> getJoinedEvents(String email) {
            // 1. Find User
            User user = userRepo.findByEmail(email)
                    .orElseThrow(() -> new UsernameNotFoundException("User not found"));

            // 2. Get ONLY the IDs of events they joined
            List<Long> joinedEventIds = eventRepo.findEventIdsByParticipantId(user.getID());

            // 3. Loop through IDs and fetch details (As you requested)
            List<GetAllEventsDTO> responseList = new java.util.ArrayList<>();

            for (Long eventId : joinedEventIds) {
                // Find by ID
                Event event = eventRepo.findById(eventId).orElse(null);

                if (event != null) {
                    // Map to DTO
                    responseList.add(new GetAllEventsDTO(
                            event.getId(),
                            event.getTitle(),
                            event.getDescription(),
                            event.getEvent_date(),
                            event.isVisible(),
                            // Keeping your hardcoded image logic for now
                            "http://192.168.1.14:8080/uploads/11.jpg"
                    ));
                }
            }

            return responseList;
        }
        @Override
        public List<EventDetailsDTO> getMyJoinedEvents(String email) {
            User user = userRepo.findByEmail(email)
                    .orElseThrow(() -> new UsernameNotFoundException("User not found"));

            // 1. Get just the IDs
            List<Long> eventIds = eventRepo.findEventIdsByParticipantId(user.getID());

            // 2. (Optional) If you need the full details for each, you can now loop or fetch them
            // This matches your flow: "find just the events ids... then we will use eventrepo find by id"
            List<EventDetailsDTO> result = new ArrayList<>();

            for (Long id : eventIds) {
                // Reuse your existing getEventDetails logic
                result.add(getEventDetails(id, email));
            }

            return result;
        }

        @Override
        public Long createEvent(CreateEventDTO dto, User user) {
            Event event = new Event();
            event = userMapper.toEntity(dto, user);
            eventRepo.save(event);
            return event.getId();
        }

        // Inside your Service class

        @Override
        public EventDetailsDTO getEventDetails(Long eventId, String currentUserEmail) {
            // 1. Fetch Event
            Event event = eventRepo.findById(eventId)
                    .orElseThrow(() -> new RuntimeException("Event not found"));

            // 2. Check ownership
            boolean isOwner = event.getOwner().getEmail().equals(currentUserEmail);

            // 3. FETCH IMAGES MANUALLY from the repo
            List<String> rawImageLinks = eventRepo.findImagesByEventId(eventId);

            // 4. Process the links (Add base URL if needed)
            List<String> fullImageLinks = rawImageLinks.stream()
                    .map(link -> link.startsWith("http") ? link : "http://10.0.2.2:8080/uploads/" + link)
                    .toList();

            // 5. Map to DTO
            return new EventDetailsDTO(
                    event.getId(),
                    event.getTitle(),
                    event.getDescription(),
                    event.getEvent_date(),
                    event.getCreated_at(),
                    event.isVisible(),
                    event.getOwner().getUsername(),
                    "http://192.168.1.14:8080/uploads/" + event.getOwner().getID() + ".jpg",
                    fullImageLinks,      // Pass the manually fetched list
                    fullImageLinks.size(),
                    isOwner
            );
        }

        @Override
        public void updateProfilePicture(UpdateProfilePictureDTO dto) {
            if (dto.file () == null || dto.file().isEmpty()) {
                throw new RuntimeException("File cannot be empty");
            }

            try {
                // 2. Define the upload directory (Project Root/uploads)
                String projectRoot = System.getProperty("user.dir");
                Path uploadPath = Paths.get(projectRoot, "uploads");

                // 3. Create directory if it doesn't exist
                if (!Files.exists(uploadPath)) {
                    Files.createDirectories(uploadPath);
                }

                // 4. Set the filename to [userId].jpg
                String fileName = dto.Id() + ".jpg";
                File destinationFile = uploadPath.resolve(fileName).toFile();

                // 5. Convert & Save (This handles the Overwrite automatically)
                saveAsJpg(dto.file(), destinationFile);

            } catch (IOException e) {
                e.printStackTrace();
                throw new RuntimeException("Failed to save profile picture");
            }

        }

        @Override
        public boolean updatePassword(UpdatePasswordDTO dto){
            if(!passwordEncoder.matches(dto.old(), dto.user().getPassword()))return false;
            dto.user().setPassword(passwordEncoder.encode(dto.newPassword()));
            userRepo.save(dto.user());
            return true;
        }
        @Override
        @Transactional
        public void sendFriendRequest(Long receiverId, String senderEmail) {
            User sender = userRepo.findByEmail(senderEmail)
                    .orElseThrow(() -> new UsernameNotFoundException("Sender not found"));
            User receiver = userRepo.findById(receiverId)
                    .orElseThrow(() -> new RuntimeException("Receiver not found"));

            // Prevent sending request to yourself
            if (sender.getID().equals(receiverId)) {
                throw new RuntimeException("You cannot send a friend request to yourself");
            }

            // Check if any relationship (Pending, Accepted, Rejected) already exists
            boolean exists = friendshipRepo.findBySenderIdAndReceiverId(sender.getID(), receiverId).isPresent() ||
                    friendshipRepo.findBySenderIdAndReceiverId(receiverId, sender.getID()).isPresent();

            if (exists) {
                throw new RuntimeException("A friend request or friendship already exists");
            }

            Friendship friendship = new Friendship();
            friendship.setSender(sender);
            friendship.setReceiver(receiver);
            friendship.setStatus(Friendship.FriendStatus.PENDING);
            friendshipRepo.save(friendship);
        }

        @Override
        @Transactional
        public void respondToFriendRequest(Long requestId, String action) {
            Friendship friendship = friendshipRepo.findById(requestId)
                    .orElseThrow(() -> new RuntimeException("Friend request not found"));

            if ("accept".equalsIgnoreCase(action)) {
                friendship.setStatus(Friendship.FriendStatus.ACCEPTED);
                friendshipRepo.save(friendship);
            } else if ("reject".equalsIgnoreCase(action)) {
                // We delete on reject to allow them to request again later,
                // or set to REJECTED status if you want to block future requests.
                friendshipRepo.delete(friendship);
            }
        }

        @Override
        public List<FriendDTO> getFriendsList(String currentUserEmail) {
            User user = userRepo.findByEmail(currentUserEmail)
                    .orElseThrow(() -> new UsernameNotFoundException("User not found"));

            List<Friendship> friendships = friendshipRepo.findAllAcceptedFriends(user.getID());

            return friendships.stream().map(f -> {
                // Determine who the "friend" is (the one who isn't the current user)
                User friend = f.getSender().getID().equals(user.getID()) ? f.getReceiver() : f.getSender();

                return new FriendDTO(
                        friend.getID(),
                        friend.getFullName(),
                        friend.getUsername(),
                        baseUrl + "/uploads/" + friend.getID() + ".jpg"
                );
            }).toList();
        }

        @Override
        public List<FriendRequestDTO> getPendingRequests(String currentUserEmail) {
            User user = userRepo.findByEmail(currentUserEmail)
                    .orElseThrow(() -> new UsernameNotFoundException("User not found"));

            List<Friendship> requests = friendshipRepo.findPendingRequestsForUser(user.getID());

            return requests.stream().map(req -> new FriendRequestDTO(
                    req.getId(),
                    req.getSender().getFullName(),
                    req.getSender().getUsername(),
                    baseUrl + "/uploads/" + req.getSender().getID() + ".jpg"
            )).toList();
        }

        @Override
        public List<FriendDTO> searchUsers(String query, String currentUserEmail) {
            User currentUser = userRepo.findByEmail(currentUserEmail)
                    .orElseThrow(() -> new UsernameNotFoundException("User not found"));

            // ✅ Fixed: Removed the extra '(' before query
            List<User> users = userRepo.findByUsernameContainingIgnoreCaseOrFullNameContainingIgnoreCase(query, query);

            return users.stream()
                    .filter(u -> !u.getID().equals(currentUser.getID())) // Don't show myself
                    .map(u -> new FriendDTO(
                            u.getID(),
                            u.getFullName(),
                            u.getUsername(),
                            baseUrl + "/uploads/" + u.getID() + ".jpg"
                    )).toList();
        }

        // ---------------------------------------------------------
        // NEW FEATURE: Bulk Invite Friends to Event
        // ---------------------------------------------------------
        @Override
        @Transactional
        public void inviteFriendsToEvent(Long eventId, List<Long> friendIds) {
            // 1. Fetch Event
            Event event = eventRepo.findById(eventId)
                    .orElseThrow(() -> new RuntimeException("Event not found with ID: " + eventId));

            // 2. Fetch all Friends to be invited
            // findAllById is a standard JPA method, it returns all users matching the IDs
            List<User> friends = userRepo.findAllById(friendIds);

            if (friends.isEmpty()) {
                throw new RuntimeException("No valid friends found to invite.");
            }

            // 3. Add them to participants if not already there
            int addedCount = 0;
            for (User friend : friends) {
                if (!event.getParticipants().contains(friend)) {
                    event.getParticipants().add(friend);
                    addedCount++;
                }
            }

            // 4. Save updates (JPA handles the relationship table insert)
            eventRepo.save(event);

            System.out.println("Invited " + addedCount + " new users to event " + eventId);
        }

        // ---------------------------------------------------------
        // NEW FEATURE: Join Event via QR Code (Single User)
        // ---------------------------------------------------------
        @Override
        @Transactional
        public void joinEventViaQr(Long eventId, String userEmail) {
            // 1. Find the User scanning the QR
            User user = userRepo.findByEmail(userEmail)
                    .orElseThrow(() -> new UsernameNotFoundException("User not found"));

            // 2. Find the Event
            Event event = eventRepo.findById(eventId)
                    .orElseThrow(() -> new RuntimeException("Event not found or invalid QR code"));

            // 3. Check if already joined
            if (event.getParticipants().contains(user)) {
                // Optional: You could throw an exception or just return silently
                throw new RuntimeException("You have already joined this event!");
            }

            // 4. Add User
            event.getParticipants().add(user);

            // 5. Save
            eventRepo.save(event);
        }

        @Transactional
        @Override
        public void uploadImages(List<UploadImageDTO> dtos, Long eventId, Long uploaderId) {

            // Check if event exists (optional, but good for safety)
            if (!eventRepo.existsById(eventId)) {
                throw new RuntimeException("Event not found");
            }

            // Loop through the URLs sent by the frontend
            for (UploadImageDTO dto : dtos) {
                // "Just save the URL, EventID, and UploaderID"
                eventRepo.saveEventImageRaw(eventId, uploaderId, dto.imageUrl());
            }
        }


        //functions
        private void sendEmail(String email, String otp) {
            SimpleMailMessage message = new SimpleMailMessage();
            message.setFrom("ahmadalmanasrah204@gmail.com");
            message.setTo(email);
            message.setSubject("OTP For evently account");
            message.setText("Hello, this is your otp: " + otp + " for evently account");
            javaMailSender.send(message);
        }

        private String otpGenerator() {
            return String.valueOf(100000 + (int) (Math.random() * 900000));
        }


        private void saveAsJpg(MultipartFile sourceFile, File destination) throws IOException {
            BufferedImage originalImage = ImageIO.read(sourceFile.getInputStream());
            if (originalImage == null) {
                throw new IOException("Uploaded file is not a valid image");
            }

            // Create a blank WHITE image (to handle transparency in PNGs)
            BufferedImage newImage = new BufferedImage(
                    originalImage.getWidth(),
                    originalImage.getHeight(),
                    BufferedImage.TYPE_INT_RGB
            );

            Graphics2D g = newImage.createGraphics();
            g.setColor(Color.WHITE);
            g.fillRect(0, 0, newImage.getWidth(), newImage.getHeight());
            g.drawImage(originalImage, 0, 0, null);
            g.dispose();

            // Write the file (Overwrites if exists)
            ImageIO.write(newImage, "jpg", destination);
        }

    }

