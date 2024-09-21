package com.example.knu_mingle.service;

import com.example.knu_mingle.domain.User;
import com.example.knu_mingle.dto.UserRegisterRequest;
import com.example.knu_mingle.dto.UserRegisterResponse;
import com.example.knu_mingle.repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class UserService {
    @Autowired
    private UserRepository userRepository;

    public User getUserByEmail(String email){
        return userRepository.findByEmail(email).orElse(null);
    }

    public UserRegisterResponse createUser(UserRegisterRequest userInfo) {
        User user = userRepository.save(userInfo.to());
        return new UserRegisterResponse(user.getId());
    }
}
