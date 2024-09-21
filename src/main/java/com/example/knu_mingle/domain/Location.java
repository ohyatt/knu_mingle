package com.example.knu_mingle.domain;

import com.example.knu_mingle.domain.Enum.Language;
import jakarta.persistence.*;

import java.util.List;

@Entity
@Table(name = "location")
public class Location {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "location_id")
    private Long id;

    @Column(name = "name",nullable = false, length = 40)
    private String name;

    @Column(name = "address", nullable = false)
    private String address;

    @Column(name ="sector", nullable = false, length = 40)
    private String sector;

    @Enumerated(EnumType.STRING)
    @Column(name = "language")
    private Language language;
}
