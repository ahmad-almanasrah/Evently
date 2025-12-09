package com.example.evently.controller;


import com.example.evently.dto.ProfileDTO;
import com.example.evently.service.UserService;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.security.Principal;
import java.util.Map;


@RestController
@RequestMapping("/home")
public class HomeController {
    private final UserService userService;

    public HomeController(UserService userService) {
        this.userService = userService;
    }


    @GetMapping("/profile")
    public ResponseEntity<ProfileDTO> getProfile(Authentication auth) {
        String email = auth.getName();
        ProfileDTO userProfile = userService.getUserProfile(email);
        return ResponseEntity.ok(userProfile);
    }


    @GetMapping("/homee")
    String home(Authentication p){
    return "Hello World " + p.getName();
}
}
