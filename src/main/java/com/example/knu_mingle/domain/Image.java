package com.example.knu_mingle.domain;

import jakarta.persistence.*;
import org.springframework.stereotype.Repository;

@Entity
@Table(name = "image")
public class Image {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "image_id")
    private Long id;

    @ManyToOne(optional = false)
    @JoinColumn(name = "review_id", nullable = false)
    private Review review;

    @ManyToOne(optional = false)
    @JoinColumn(name = "market_id", nullable = false)
    private Market market;

    @Column(name = "path",nullable = false)
    private String path;
}
