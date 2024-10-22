package com.example.knu_mingle.dto;

import com.example.knu_mingle.domain.Enum.Keyword;
import com.example.knu_mingle.domain.Enum.Reaction;
import com.example.knu_mingle.domain.Image;
import com.example.knu_mingle.domain.Review;
import com.example.knu_mingle.domain.ReviewImage;
import lombok.Getter;
import lombok.Setter;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

@Getter
@Setter
public class ReviewPostResponseDto {
    private ReviewUserInfoDto userInfoDto;
    private Long id;
    private String title;
    private String content;
    private Keyword keyword;
    private LocalDateTime createdAt;
    private LocalDateTime modifiedAt;
    private Reaction reaction;
    private List<String> imageUrl;

    public ReviewPostResponseDto(Review review, ReviewImage reviewImage) {
        this.userInfoDto = new ReviewUserInfoDto(review.getUser());
        this.id = review.getId();
        this.title = review.getTitle();
        this.content = review.getContent();
        this.keyword = review.getKeyword();
        this.createdAt = review.getCreatedAt();
        this.modifiedAt = review.getModifiedAt();
        this.reaction = review.getReaction();
        if(reviewImage == null){
            this.imageUrl = new ArrayList<>();
        }
        else{
            this.imageUrl = reviewImage.getPath();
        }
    }
}
