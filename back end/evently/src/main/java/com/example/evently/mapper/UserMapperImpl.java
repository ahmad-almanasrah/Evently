package com.example.evently.mapper;

import com.example.evently.dto.CreateUserDTO;
import com.example.evently.dto.ProfileDTO;
import com.example.evently.entity.User;
import org.springframework.context.annotation.Profile;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Component;

@Component
public class UserMapperImpl implements UserMapper{
    private final BCryptPasswordEncoder passwordEncoder;

    public UserMapperImpl(BCryptPasswordEncoder passwordEncoder) {
        this.passwordEncoder = passwordEncoder;
    }
    @Override
    public User toEntity(CreateUserDTO dto) {

        User user = new User();

        user.setUsername(dto.username().toLowerCase());
        user.setEmail(dto.email().toLowerCase());
        user.setPassword(passwordEncoder.encode(dto.password()));

        return user;
    }

    @Override
    public ProfileDTO toDto(User user, int friendsCount,int eventsCount, int picturesCount, String imagePath) {

        return new ProfileDTO(imagePath, user.getFullName(),user.getUsername(),friendsCount,eventsCount,picturesCount);
    }
}
