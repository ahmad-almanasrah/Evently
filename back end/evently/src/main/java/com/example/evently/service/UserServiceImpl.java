package com.example.evently.service;

import com.example.evently.dto.*;
import com.example.evently.entity.User;
import com.example.evently.mapper.UserMapper;
import com.example.evently.repo.UserRepo;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Profile;
import org.springframework.mail.SimpleMailMessage;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.List;

@Service
public class UserServiceImpl implements UserService {


    @Value("${app.base-url}")
    private String baseUrl;

    private final UserMapper userMapper;
    private String OTP  = "";
    private Long expiration ;


    private final UserRepo userRepo;
    private final BCryptPasswordEncoder passwordEncoder;
    private final JavaMailSender javaMailSender;

    public UserServiceImpl(UserRepo userRepo, BCryptPasswordEncoder passwordEncoder, JavaMailSender javaMailSender, UserMapper userMapper) {
        this.userRepo = userRepo;
        this.passwordEncoder = passwordEncoder;
        this.javaMailSender = javaMailSender;
        this.userMapper = userMapper;
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

        if(userRepo.existsByEmail(email)){
            return 2; // Email already exists
        }
        if(userRepo.existsByUsername(username)){
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
            expiration = System.currentTimeMillis()+ 5 * 60 * 1000;
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
    public boolean restUserPassword(RestPasswordDTO dto){
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
        return userMapper.toDto(user, 0, 0, 0, finalUrl);
    }
    //functions
     private void sendEmail(String email, String otp) {
         SimpleMailMessage message = new SimpleMailMessage();
         message.setFrom("ahmadalmanasrah204@gmail.com");
         message.setTo(email);
         message.setSubject("OTP For evently account");
         message.setText("Hello, this is your otp: "+otp +" for evently account");
         javaMailSender.send(message);
     }
        private String otpGenerator() {
            return String.valueOf(100000 + (int) (Math.random() * 900000));
        }
    }



