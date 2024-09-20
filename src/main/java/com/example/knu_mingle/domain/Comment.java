package com.example.knu_mingle.domain;

import jakarta.persistence.*;

@Entity
@Table(name = "comment")
public class Comment {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name="comment_id")
    private Long id;



    @ManyToOne(optional = false)
    @JoinColumn(name = "market_id", nullable = false)
    private Market market;

    @ManyToOne(optional = false)
    @JoinColumn(name = "user_id", nullable = false)
    private User user;

    @Column(name = "content", nullable = false, length = 1000)
    private String content;

    @Column(name = "isPublic", nullable = false)
    private boolean isPublic;

    @Column(name = "createdAt", nullable = false, length = 40)
    private String createdAt;
    @Column(name = "modifiedAt", nullable = false, length = 40)
    private String modifiedAt;

}
