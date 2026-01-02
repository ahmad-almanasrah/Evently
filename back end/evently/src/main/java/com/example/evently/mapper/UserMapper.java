package com.example.evently.mapper;

import com.example.evently.dto.CreateEventDTO;
import com.example.evently.dto.CreateUserDTO;
import com.example.evently.dto.ProfileDTO;
import com.example.evently.entity.Event;
import com.example.evently.entity.User;

public interface UserMapper {
    User toEntity(CreateUserDTO createUserRequestDTO);
    ProfileDTO toDto(User user, int friendsCount,int eventsCount, int picturesCount, String imagePath);
    Event toEntity(CreateEventDTO createEventDTO, User user);
}
