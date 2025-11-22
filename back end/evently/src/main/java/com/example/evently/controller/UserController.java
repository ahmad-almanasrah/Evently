package com.example.evently.controller;

import com.example.evently.dto.CreateUserDTO;
import com.example.evently.dto.LoginDTO;

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
    public Map<String, String> login(@RequestBody LoginDTO dto) {
        var auth = userService.loginUser(dto);
        String token = tokenService.generateToken(auth);
        return Map.of("token", token);
    }

    @PostMapping("/register")
    public String createUser(@RequestBody CreateUserDTO dto) {
        userService.createUser(dto);
        return "success";
    }

}

