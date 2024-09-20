package com.example.knu_mingle.controller;


import com.example.knu_mingle.domain.User;
import com.example.knu_mingle.repository.PostRepository;
import com.example.knu_mingle.repository.ReviewRepository;
import com.example.knu_mingle.repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/review")
public class ReviewRestController {

    @Autowired ReviewRepository reviewRepository;
    @Autowired UserRepository userRepository;

    @GetMapping
    public

    @PostMapping("/register")
    public ResponseEntity<String> registerUser(@RequestBody User user) {
        userrepository.save(user);
        return new ResponseEntity<>("User registered successfully", HttpStatus.CREATED);
    }







}
