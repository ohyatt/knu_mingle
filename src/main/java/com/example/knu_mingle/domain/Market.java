package com.example.knu_mingle.domain;

import jakarta.persistence.*;

@Entity
@Table(name="market")
public class Market {


    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name="market_id")
    private Long id;



    @ManyToOne(optional = false)
    @JoinColumn(name = "user_id", nullable = false)
    private User user;

    @Column(name = "title", nullable = false, length = 20)
    private String title;

    @Column(name = "content", nullable = false, length = 1000)

    private String content;

    @Column(name = "method", nullable = false, length = 40)
    private String method;
    @Column(name = "createdAt", nullable = false, length = 40)
    private String createdAt;
    @Column(name = "modifiedAt", nullable = false, length = 40)
    private String modifiedAt;


}
