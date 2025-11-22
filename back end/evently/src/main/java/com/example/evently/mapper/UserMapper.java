package com.example.evently.mapper;

import com.example.evently.dto.CreateUserDTO;
import com.example.evently.entity.User;

public interface UserMapper {
    User toEntity(CreateUserDTO createUserRequestDTO);
}
