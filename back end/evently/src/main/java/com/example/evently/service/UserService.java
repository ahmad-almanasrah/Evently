package com.example.evently.service;

import com.example.evently.dto.CreateUserDTO;
import com.example.evently.dto.LoginDTO;
import org.springframework.security.core.Authentication;

public interface UserService {
    Authentication loginUser(LoginDTO dto);
    void createUser (CreateUserDTO dto);
}
