package com.example.knu_mingle.dto;

import com.example.knu_mingle.domain.Enum.Keyword;
import com.example.knu_mingle.domain.Enum.Reaction;
import com.example.knu_mingle.domain.Review;
import lombok.Getter;
import lombok.Setter;

import java.util.List;

@Getter
@Setter
public class ReviewUpdateDto {
    private Keyword keyword;
    private String title;
    private String content;
    private Reaction reaction;

    private List<String> images;

    public Review update(Review review) {
        review.setKeyword(keyword);
        review.setTitle(title);
        review.setContent(content);
        review.setReaction(reaction);

        return review;
    }
}
