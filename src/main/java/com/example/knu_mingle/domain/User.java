package com.example.knu_mingle.domain;


import com.example.knu_mingle.domain.Enum.Faculty;
import com.example.knu_mingle.domain.Enum.Gender;
import com.example.knu_mingle.domain.Enum.Nation;
import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;

@Entity
@Getter
@Table(name="user")
@Setter
public class User {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name="user_id")
    private Long id;

    @Column(name = "first_name", nullable = false, length = 20)
    private String first_name;

    @Column(name = "last_name", nullable = false, length = 20)
    private String last_name;

    @Column(name= "gender", nullable = false, length =20)
    private Gender gender;

    @Column(name = "email", nullable = false, length = 20, unique = true)
    private String email;

    @Column(name = "password", nullable = false, length = 20)
    private String password;

    @Column(name = "nation", nullable = false, length = 20)
    private Nation nation;

    @Column(name = "faculty", nullable = false, length = 20)
    private Faculty faculty;


}
