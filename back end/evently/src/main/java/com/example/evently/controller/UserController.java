package com.example.evently.controller;

import com.example.evently.dto.CreateUserDTO;
import com.example.evently.dto.LoginDTO;

import com.example.evently.dto.SendOtpDTO;
import com.example.evently.dto.VerifyOtpDTO;
import com.example.evently.service.TokenService;
import com.example.evently.service.UserService;
import org.springframework.web.bind.annotation.*;

import java.util.Map;

@RestController
@RequestMapping("/auth")
public class UserController {

    private final UserService userService;
    private final TokenService tokenService;

    public UserController(UserService userService, TokenService tokenService) {
        this.userService = userService;
        this.tokenService = tokenService;
    }

    @PostMapping("/login")
    public Map<String, Object> login(@RequestBody LoginDTO dto) {
        try {
            var auth = userService.loginUser(dto);
            if (auth == null) {

                return Map.of("status", "fail", "message", "Invalid email or password");
            }
            String token = tokenService.generateToken(auth);
            return Map.of("status", "success", "token", token);
        } catch (Exception e) {
            return Map.of("status", "error", "message", e.getMessage());
        }
    }


    @PostMapping("/register")
    public String createUser(@RequestBody CreateUserDTO dto) {
        userService.createUser(dto);
        return "success";
    }

    @PostMapping("otp/request")
    public String sendOTP(@RequestBody SendOtpDTO dto) {
        userService.sendUserOTP(dto);
        return "success";
    }

    @PostMapping("otp/verify")
    public String verifyOTP(@RequestBody VerifyOtpDTO dto) {
        if(userService.verifyUserOTP(dto) == 0)
        return "success";
        return "fail";
    }


}

