package com.example.knu_mingle.domain;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
@Entity
@Table(name = "location")
public class Location {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "location_id")
    private Long id;

    @Column(name = "name",nullable = false, length = 100)
    private String name;

    @Column(name = "address", nullable = false)
    private String address;

    @Column(name ="sector", nullable = false, length = 40)
    private String sector;

    @Column(name ="phoneNumber", nullable = false, length = 40)
    private String phoneNumber;

    @Column(name = "language")
    private String language;
}
