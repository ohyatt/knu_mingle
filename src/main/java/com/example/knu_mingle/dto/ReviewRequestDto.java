package com.example.knu_mingle.dto;

import com.example.knu_mingle.domain.Enum.Keyword;
import com.example.knu_mingle.domain.Enum.Reaction;
import com.example.knu_mingle.domain.Review;
import com.example.knu_mingle.domain.User;
import lombok.Getter;
import lombok.Setter;

import java.util.List;

@Setter
@Getter
public class ReviewRequestDto {
    private Keyword keyword;
    private String title;
    private String content;
    private Reaction reaction;
    private List<String> images;

    public Review to(User user) {
        Review review = new Review();
        review.setKeyword(keyword);
        review.setTitle(title);
        review.setContent(content);
        review.setReaction(reaction);
        review.setUser(user);

        return review;
    }
}
