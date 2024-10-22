package com.example.knu_mingle.domain;

import com.example.knu_mingle.domain.Enum.Status;
import com.example.knu_mingle.dto.MarketRequestDto;
import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;

import java.time.LocalDateTime;

@Entity
@Setter
@Getter
@Table(name="market")
public class Market {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name="market_id")
    private Long id;

    @ManyToOne(optional = false)
    @JoinColumn(name = "user_id", nullable = false)
    private User user;

    @Column(name = "title", nullable = false, length = 100)
    private String title;

    @Column(name = "content", nullable = false, length = 1000)

    private String content;

    @Enumerated(EnumType.STRING)
    private Status status = Status.NONE;

    @Column(name = "method", nullable = false, length = 100)
    private String method;
    @Column(name = "createdAt", nullable = false, length = 40)
    private LocalDateTime createdAt;
    @Column(name = "modifiedAt", nullable = false, length = 40)
    private LocalDateTime modifiedAt;

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
