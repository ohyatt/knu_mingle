package com.example.knu_mingle.dto;

import com.example.knu_mingle.domain.Enum.Faculty;
import com.example.knu_mingle.domain.Enum.Gender;
import com.example.knu_mingle.domain.Enum.Nation;
import com.example.knu_mingle.domain.User;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class UserRegisterRequest {
    private String first_name;
    private String last_name;
    private Gender gender;
    private String email;
    private String password;
    private Nation nation;
    private Faculty faculty;

    public User to() {
        User user = new User();
        user.setFirst_name(first_name);
        user.setLast_name(last_name);
        user.setGender(gender);
        user.setEmail(email);
        user.setPassword(password);
        user.setNation(nation);
        user.setFaculty(faculty);
        return user;
    }
}
