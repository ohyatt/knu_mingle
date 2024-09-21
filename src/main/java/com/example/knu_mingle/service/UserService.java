package com.example.knu_mingle.service;

import com.example.knu_mingle.domain.User;
import com.example.knu_mingle.dto.LoginRequestDto;
import com.example.knu_mingle.dto.LoginResponseDto;
import com.example.knu_mingle.dto.UserRegisterRequest;
import com.example.knu_mingle.dto.UserRegisterResponse;
import com.example.knu_mingle.repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.NoSuchElementException;

@Service
public class UserService {
    @Autowired
    private UserRepository userRepository;
    private JwtService jwtService;

    public User getUserByEmail(String email) {
        return userRepository.findByEmail(email)
                .orElseThrow(() -> new NoSuchElementException("User not found with email: " + email));
    }

    public UserRegisterResponse createUser(UserRegisterRequest userInfo) {
        User user = userRepository.save(userInfo.to());
        return new UserRegisterResponse(user.getId());
    }

    public LoginResponseDto login(LoginRequestDto loginRequestDto) {
        User user = getUserByEmail(loginRequestDto.getEmail());
        if(user.getPassword().equals(loginRequestDto.getPassword())){
            String token = jwtService.generateToken(user.getEmail());
            return new LoginResponseDto(token, user.getId());
        }
        throw new IllegalArgumentException("Invalid email or password");
    }
}
