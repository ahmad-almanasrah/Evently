package com.example.evently.controller;

import com.example.evently.dto.*;

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
        public Map<String, Object> createUser(@RequestBody CreateUserDTO dto) {
            int result = userService.createUser(dto);

            return switch (result) {
                case 1 -> Map.of("status", "success", "message", "User created successfully");
                case 2 -> Map.of("status", "fail", "message", "Email already exists");
                case 3 -> Map.of("status", "fail", "message", "Username already exists");
                default -> Map.of("status", "fail", "message", "Unknown error occurred");
            };
        }



//    @PostMapping("/otp/request")
//    public map<String,String> sendOTP(@RequestBody SendOtpDTO dto) {
//        userService.sendUserOTP(dto);
//        return Map.of("status","success");
//    }

    @PostMapping("/otp/verify")
    public String verifyOTP(@RequestBody VerifyOtpDTO dto) {
        if(userService.verifyUserOTP(dto) == 0)
        return "success";
        return "fail";
    }

    @PostMapping("/resetPassword")
    public String resetPasswrod(@RequestBody RestPasswordDTO dto){
        if(userService.restUserPassword(dto))
            return "success";
        return "fail";
    }



}

