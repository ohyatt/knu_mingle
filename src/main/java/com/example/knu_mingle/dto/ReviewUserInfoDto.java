package com.example.knu_mingle.dto;

import com.example.knu_mingle.domain.Enum.Faculty;
import com.example.knu_mingle.domain.Enum.Gender;
import com.example.knu_mingle.domain.Enum.Nation;
import com.example.knu_mingle.domain.User;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class ReviewUserInfoDto {
    private Long id;
    private String first_name;
    private String last_name;
    private Gender gender;
    private String email;
    private Nation nation;
    private Faculty faculty;

    public ReviewUserInfoDto(User user) {
        this.id = user.getId();
        this.first_name = user.getFirst_name();
        this.last_name = user.getLast_name();
        this.gender = user.getGender();
        this.email = user.getEmail();
        this.nation = user.getNation();
        this.faculty = user.getFaculty();
    }
}
