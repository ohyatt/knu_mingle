package com.example.knu_mingle.controller;


import com.example.knu_mingle.domain.User;
import com.example.knu_mingle.dto.UserRegisterRequest;
import com.example.knu_mingle.dto.UserRegisterResponse;
import com.example.knu_mingle.repository.MarketRepository;
import com.example.knu_mingle.repository.UserRepository;
import com.example.knu_mingle.service.MailManager;
import com.example.knu_mingle.service.SHA256Util;
import com.example.knu_mingle.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.UUID;

@org.springframework.web.bind.annotation.RestController
@RequestMapping("/auth")
public class AuthRestController {

    @Autowired
    MarketRepository marketRepository;
    UserRepository userRepository;


    MailManager mailManager;
    @Autowired
    private UserService userService;

    @PostMapping("/register")
    public ResponseEntity<UserRegisterResponse> registerUser(@RequestBody UserRegisterRequest userInfo) {
        UserRegisterResponse response = userService.createUser(userInfo);
        return ResponseEntity.ok(response);
    }

    @GetMapping("/duplicate")
    public boolean EmailDuplicate(@RequestParam String email) {
        return userRepository.findByEmail(email).isPresent();
    }

    @PostMapping("/sendMail") //
    @ResponseBody  //AJAX후 값을 리턴하기위해 작성
    public String SendMail(String email) throws Exception {
        UUID uuid = UUID.randomUUID(); // 랜덤한 UUID 생성
        String key = uuid.toString().substring(0, 7); // UUID 문자열 중 7자리만 사용하여 인증번호 생성
        String sub ="인증번호 입력을 위한 메일 전송";
        String con = "인증 번호 : "+key;
        mailManager.send(email,sub,con);
        key = SHA256Util.getEncrypt(key, email);
        return key;
    }
    @PostMapping("/checkMail") //
    @ResponseBody
    public boolean CheckMail(String key, String insertKey,String email) throws Exception {
        insertKey = SHA256Util.getEncrypt(insertKey, email);

        if(key.equals(insertKey)) {
            return true;
        }
        return false;
    }

    @DeleteMapping("/{userId}")
    public ResponseEntity<String> deleteUser(@PathVariable Long userId) {
        try {
            if (userRepository.existsById(userId)) {
                userRepository.deleteById(userId);
            } else {
                throw new IllegalArgumentException("해당 ID의 사용자를 찾을 수 없습니다.");
            }

            return ResponseEntity.ok("회원 탈퇴가 성공적으로 처리되었습니다.");
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body("회원 탈퇴 중 오류가 발생했습니다.");
        }
    }










}
