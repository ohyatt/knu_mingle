package com.example.knu_mingle.controller;

import com.example.knu_mingle.domain.User;
import com.example.knu_mingle.dto.LoginRequestDto;
import com.example.knu_mingle.dto.LoginResponseDto;
import com.example.knu_mingle.dto.UserRegisterRequest;
import com.example.knu_mingle.dto.UserRegisterResponse;
import com.example.knu_mingle.service.MailManager;
import com.example.knu_mingle.service.SHA256Util;
import com.example.knu_mingle.service.UserService;
import io.swagger.v3.oas.annotations.Operation;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpHeaders;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.UUID;

@org.springframework.web.bind.annotation.RestController
@RequestMapping("/auth")
public class AuthRestController {




    @Autowired
    MailManager mailManager;
    @Autowired
    private UserService userService;

    @Operation(summary = "회원가입")
    @PostMapping("/register")
    public ResponseEntity<UserRegisterResponse> registerUser(@RequestBody UserRegisterRequest userInfo) {
        UserRegisterResponse response = userService.createUser(userInfo);
        return ResponseEntity.ok(response);
    }

    @Operation(summary = "이메일 중복 확인")
    @GetMapping("/duplicate")
    public ResponseEntity<Boolean> EmailDuplicate(@RequestParam String email) {
        return ResponseEntity.ok(userService.emailDuplicate(email));
    }

    @Operation(summary = "로그인")
    @PostMapping("/login")
    public ResponseEntity<LoginResponseDto> Login(@RequestBody LoginRequestDto loginRequestDto) {
        return ResponseEntity.ok(userService.login(loginRequestDto));
    }

    @PostMapping("/sendMail") //
    @ResponseBody  //AJAX후 값을 리턴하기위해 작성
    public String SendMail(String email) throws Exception {
        UUID uuid = UUID.randomUUID(); // 랜덤한 UUID 생성
        String key = uuid.toString().substring(0, 7); // UUID 문자열 중 7자리만 사용하여 인증번호 생성
        String sub ="[KNU MINGLE] This is VERFICATION NUMBER MAIL.";
        String con = "Welcome to KNU MINGLE!\n This is VERFICATION NUMBER MAIL.\n VERIFICATION NUMBER : "+key+"\n \n" +
                "This is a verification number, so if you enter it, email verification will be completed. ";
        mailManager.send(email,sub,con);
        key = SHA256Util.getEncrypt(key, email);
        return key;
    }
    @PostMapping("/checkMail") //
    @ResponseBody
    public boolean CheckMail(String key, String insertKey,String email) throws Exception {

        System.out.println(insertKey);

        insertKey = SHA256Util.getEncrypt(insertKey, email);



        System.out.println(key);
        System.out.println(insertKey);



        if(key.equals(insertKey)) {
            return true;
        }
        return false;
    }

    @Operation(summary = "회원탈퇴")
    @DeleteMapping()
    public ResponseEntity<String> deleteUser(@RequestHeader(HttpHeaders.AUTHORIZATION) String accessToken) {
        return ResponseEntity.ok(userService.deleteUser(accessToken));
    }

    @PostMapping("/find")
    @ResponseBody
    public ResponseEntity<User> findPassword(@RequestParam String email) throws Exception {

        String sub = "[KNU MINGLE] Hello, This is your NEW PASSWORD!!";

        UUID uuid = UUID.randomUUID(); // 랜덤한 UUID 생성
        String new_password = uuid.toString().substring(0, 7);

        String con = "[KNU MINGLE] \n YOUR NEW PASSWORD : "+new_password;



        mailManager.send(email, sub, con);



        return ResponseEntity.ok(userService.newPassword(email,new_password));


    }

}
