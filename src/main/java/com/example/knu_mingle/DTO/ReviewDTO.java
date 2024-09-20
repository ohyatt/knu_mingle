package com.example.knu_mingle.DTO;

public class ReviewDTO {
    private String title; // 리뷰 제목
    private String content; // 리뷰 내용
    private String keyword; // 리뷰 키워드

    // 모든 필드를 초기화하는 생성자
    public ReviewDTO(String title, String content, String keyword) {
        this.title = title;
        this.content = content;
        this.keyword = keyword;
    }

    // 제목만 초기화하는 생성자
    public ReviewDTO(String title) {
        this(title, "", "");
    }

    // Getters
    public String getTitle() {
        return title;
    }

    public String getContent() {
        return content;
    }

    public String getKeyword() {
        return keyword;
    }
}
