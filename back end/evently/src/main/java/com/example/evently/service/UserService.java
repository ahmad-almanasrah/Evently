package com.example.evently.service;

import com.example.evently.dto.*;
import org.springframework.security.core.Authentication;

public interface UserService {
    Authentication loginUser(LoginDTO dto);
    int createUser (CreateUserDTO dto);
    void sendUserOTP(SendOtpDTO dto);
    int verifyUserOTP(VerifyOtpDTO dto);
    boolean restUserPassword(RestPasswordDTO dto);
    ProfileDTO getUserProfile(String email);
}
