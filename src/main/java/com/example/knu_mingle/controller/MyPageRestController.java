package com.example.knu_mingle.controller;


import com.example.knu_mingle.domain.User;
import com.example.knu_mingle.repository.MarketRepository;
import com.example.knu_mingle.repository.UserRepository;
import com.example.knu_mingle.service.MyPageService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@org.springframework.web.bind.annotation.RestController
@RequestMapping("/mypage")
public class MyPageRestController {

    @Autowired
    MyPageService mypageService;


    @GetMapping("/{userId}")
    public ResponseEntity<User> MyPage(@PathVariable Long userId) {
        return new ResponseEntity<>(mypageService.MyPage(userId), HttpStatus.CREATED);

    }

    @PutMapping("/update")
    public ResponseEntity<User> MyPageUpdate(@RequestBody User user)
    {
        return new ResponseEntity<>(mypageService.MyPageUpdate(user),HttpStatus.CREATED);
    }











}
