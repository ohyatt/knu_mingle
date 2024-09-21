package com.example.knu_mingle.dto;

import com.example.knu_mingle.domain.Enum.Feeling;
import com.example.knu_mingle.domain.Rating;
import com.example.knu_mingle.domain.Review;
import com.example.knu_mingle.domain.User;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class RateRequestDto {
    private Feeling feeling;

    public Rating to(Review review, User user){
        Rating rating = new Rating();
        rating.setFeeling(feeling);
        rating.setReview(review);
        rating.setUser(user);

        return rating;
    }
}
