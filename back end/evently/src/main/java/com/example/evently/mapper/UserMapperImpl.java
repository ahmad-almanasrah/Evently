package com.example.evently.mapper;

import com.example.evently.dto.CreateEventDTO;
import com.example.evently.dto.CreateUserDTO;
import com.example.evently.dto.ProfileDTO;
import com.example.evently.entity.Event;
import com.example.evently.entity.User;
import com.example.evently.repo.UserRepo;
import org.springframework.context.annotation.Profile;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Component;

import java.time.LocalDateTime;

@Component
public class UserMapperImpl implements UserMapper{
    private final BCryptPasswordEncoder passwordEncoder;
//    private final  UserRepo userRepo;

    public UserMapperImpl(BCryptPasswordEncoder passwordEncoder, UserRepo userRepo) {
        this.passwordEncoder = passwordEncoder;
//        this.userRepo = userRepo;
    }
    @Override
    public User toEntity(CreateUserDTO dto) {

        User user = new User();

        user.setUsername(dto.username().toLowerCase());
        user.setEmail(dto.email().toLowerCase());
        user.setPassword(passwordEncoder.encode(dto.password()));

        return user;
    }

    public Event toEntity(CreateEventDTO dto , User user) {

        Event event = new Event();
        event.setOwner(user);
        event.setTitle(dto.title());
        event.setDescription(dto.description());
        event.setVisible(dto.isPublic());
//        event.setCover_image(dto.coverImage());
        event.setEvent_date(dto.eventDate());
        event.setCreated_at(LocalDateTime.now());

        return event;
    }

    @Override
    public ProfileDTO toDto(User user, int friendsCount,int eventsCount, int picturesCount, String imagePath) {

        return new ProfileDTO(imagePath, user.getFullName(),user.getUsername(),friendsCount,eventsCount,picturesCount);
    }
}
