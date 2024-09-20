package com.example.knu_mingle.service;

import com.example.knu_mingle.domain.User;
import com.example.knu_mingle.repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.Optional;

@Service
public class UserService {
    @Autowired
    private UserRepository userRepository;

    public Optional<User> getUserByEmail(String email){
        return userRepository.findByEmail(email);
    }
}
