package com.example.evently.service;

import com.example.evently.dto.CreateUserDTO;
import com.example.evently.dto.LoginDTO;
import com.example.evently.dto.SendOtpDTO;
import com.example.evently.dto.VerifyOtpDTO;
import org.springframework.security.core.Authentication;

public interface UserService {
    Authentication loginUser(LoginDTO dto);
    void createUser (CreateUserDTO dto);
    void sendUserOTP(SendOtpDTO dto);
    int verifyUserOTP(VerifyOtpDTO dto);
}
