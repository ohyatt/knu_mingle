package com.example.knu_mingle.domain;

import jakarta.persistence.*;
import org.springframework.beans.factory.annotation.Autowired;

@Entity
@Table(name="post")
public class Post {


    @Id
     private Long id;



    @ManyToOne(optional = false)
    @JoinColumn(name = "user_id", nullable = false)
    private User user;

    @Column(name = "name", nullable = false, length = 20)
    private String title;

    @Column(name = "content", nullable = false, length = 200)

    private String content;

    @Column(name = "image_url", nullable = false, length = 40)

    private String image_url;

}
