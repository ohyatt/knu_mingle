package com.example.knu_mingle.domain;


import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.Table;
import lombok.Getter;

@Entity
@Getter
@Table(name="user")
public class User {

    @Id
    private Long id;


    @Column(name = "name", nullable = false, length = 20)
    private String name;

    @Column(name = "email", nullable = false, length = 20)
    private String email;

    @Column(name = "password", nullable = false, length = 20)
    private String password;

    @Column(name = "nation", nullable = false, length = 20)
    private String nation;

    @Column(name = "birth", nullable = false, length = 20)
    private String birth;

}
