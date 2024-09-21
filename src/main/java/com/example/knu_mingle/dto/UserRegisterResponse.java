package com.example.knu_mingle.dto;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class UserRegisterResponse {
    private Long user_id;

    public UserRegisterResponse(Long id) {
        this.user_id = id;
    }
}
