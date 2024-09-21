package com.example.knu_mingle.dto;

import com.example.knu_mingle.domain.Enum.Keyword;
import com.example.knu_mingle.domain.Enum.Reaction;
import com.example.knu_mingle.domain.Review;
import com.example.knu_mingle.domain.User;
import lombok.Getter;

@Getter
public class ReviewRequestDto {
    private Keyword keyword;
    private String title;
    private String content;
    private Reaction reaction;

    public Review to() {
        Review review = new Review();
        review.setKeyword(keyword);
        review.setTitle(title);
        review.setContent(content);
        review.setReaction(reaction);

        return review;
    }
}
