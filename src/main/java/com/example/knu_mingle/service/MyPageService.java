package com.example.knu_mingle.service;

import com.example.knu_mingle.domain.User;
import com.example.knu_mingle.repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;


@Service
public class MyPageService {


    @Autowired
    UserRepository userRepository;
    @Autowired
    UserService userService;

    public User MyPage(String accessToken)
    {
        return userService.getUserByToken(accessToken);
    }

    public User MyPageUpdate(User user)
    {
        return userRepository.save(user);
    }
}
