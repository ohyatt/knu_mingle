package com.example.knu_mingle.dto;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class LoginResponseDto {
    public String token;
    public Long userId;

    public LoginResponseDto(String token, Long id) {
        this.token = token;
        this.userId = id;
    }
}
