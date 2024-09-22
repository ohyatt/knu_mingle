package com.example.knu_mingle.service;


import com.example.knu_mingle.domain.User;
import com.example.knu_mingle.repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class AuthService {


    @Autowired
    UserRepository userRepository;

    public User CreateUser(User user)
    {
        return userRepository.save(user);
    }

    public boolean DuplicateEmail(String email)
    {
        return userRepository.findByEmail(email).isPresent();
    }

    public void DeleteUser(Long userId)
    {
        if (userRepository.existsById(userId)) {
            userRepository.deleteById(userId);
        } else {
            throw new IllegalArgumentException("해당 ID의 사용자를 찾을 수 없습니다.");
        }

    }




}
