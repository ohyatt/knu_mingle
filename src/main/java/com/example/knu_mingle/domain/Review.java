package com.example.knu_mingle.domain;

import com.example.knu_mingle.domain.Enum.Keyword;
import com.example.knu_mingle.domain.Enum.Reaction;
import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;
import org.springframework.cglib.core.Local;

import java.time.LocalDateTime;

@Entity
@Getter
@Setter
@Table(name="review")
public class Review {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name="review_id")
    private Long id;

    @ManyToOne(optional = false)
    @JoinColumn(name = "user_id", nullable = false)
    private User user;

    @Column(name = "keyword", nullable = false)
    private Keyword keyword;

    @Column(name = "title", nullable = false, length = 20)
    private String title;

    @Column(name = "content", nullable = false, length = 1000)
    private String content;

    @Column(name = "createdAt", nullable = false, length = 40)
    private LocalDateTime createdAt;
    @Column(name = "modifiedAt", nullable = false, length = 40)
    private LocalDateTime modifiedAt;

    @Column(name = "reaction", nullable = false, length = 20)
    private Reaction reaction;

    /*public Review(User user,Keyword keyword, String title, String content, Reaction reaction) {
        this.user = user;
        this.keyword = keyword;
        this.title = title;
        this.content = content;
        this.reaction = reaction;
    }**/

    @PrePersist
    protected void onCreate() {
        LocalDateTime now = LocalDateTime.now();
        createdAt = now;
        modifiedAt = now;
    }

    @PreUpdate
    protected void onUpdate() {
        modifiedAt = LocalDateTime.now();
    }


}
