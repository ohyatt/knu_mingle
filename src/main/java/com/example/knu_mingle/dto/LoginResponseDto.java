package com.example.knu_mingle.dto;

public class LoginResponseDto {
    public String token;
    public Long userId;

    public LoginResponseDto(String token, Long id) {
        this.token = token;
        this.userId = id;
    }
}
