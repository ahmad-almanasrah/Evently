package com.example.evently.service;

import com.example.evently.dto.CreateUserDTO;
import com.example.evently.dto.LoginDTO;
import com.example.evently.entity.User;
import com.example.evently.repo.UserRepo;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
public class UserServiceImpl implements UserService {

    private final UserRepo userRepo;
    private final BCryptPasswordEncoder passwordEncoder;

    public UserServiceImpl(UserRepo userRepo, BCryptPasswordEncoder passwordEncoder) {
        this.userRepo = userRepo;
        this.passwordEncoder = passwordEncoder;
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
                user.getUsername(), // or email if you prefer
                null,
                List.of(new SimpleGrantedAuthority("read"))
        );
    }

    @Override
    @Transactional
    public void createUser(CreateUserDTO dto){
        String email = dto.email().toLowerCase().trim();
        String password = dto.password();
        String username = dto.username();

        if(userRepo.existsByEmail(email)){
            throw new RuntimeException("Email already exists");
        }
        if(userRepo.existsByUsername(username)){
            throw new RuntimeException("Username already exists");
        }
        User user = new User();
        user.setEmail(email);
        user.setPassword(passwordEncoder.encode(password));
        user.setUsername(username);
        userRepo.save(user);
    }
}
