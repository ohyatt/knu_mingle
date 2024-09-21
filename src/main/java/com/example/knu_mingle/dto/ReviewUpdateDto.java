package com.example.knu_mingle.dto;

import com.example.knu_mingle.domain.Enum.Keyword;
import com.example.knu_mingle.domain.Enum.Reaction;
import com.example.knu_mingle.domain.Review;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class ReviewUpdateDto {
    private Keyword keyword;
    private String title;
    private String content;
    private Reaction reaction;

    public Review update(Review review) {
        review.setKeyword(keyword);
        review.setTitle(title);
        review.setContent(content);
        review.setReaction(reaction);

        return review;
    }
}
