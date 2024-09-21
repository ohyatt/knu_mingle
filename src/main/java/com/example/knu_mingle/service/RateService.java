package com.example.knu_mingle.service;

import com.example.knu_mingle.domain.Enum.Feeling;
import com.example.knu_mingle.domain.Market;
import com.example.knu_mingle.domain.Rating;
import com.example.knu_mingle.domain.Review;
import com.example.knu_mingle.domain.User;
import com.example.knu_mingle.dto.RateRequestDto;
import com.example.knu_mingle.dto.ReviewRequestDto;
import com.example.knu_mingle.repository.RateRepository;
import com.example.knu_mingle.repository.ReviewRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestHeader;
import org.springframework.web.server.ResponseStatusException;

public class RateService {

    @Autowired
    private RateRepository rateRepository;
    @Autowired
    private ReviewService reviewService;
    @Autowired
    private UserService userService;

    //리뷰 평가
    public String rateReview(String accessToken, Long id, RateRequestDto requestDto) {
        User user = userService.getUserByToken(accessToken);
        Review review = reviewService.getReview(id);

        Rating existingRating = rateRepository.findByReviewAndUser(review, user);

        if (existingRating != null) {
            // 같은 감정을 다시 선택하는 경우
            if (existingRating.getFeeling() == requestDto.getFeeling()) {
                rateRepository.delete(existingRating);
                return "Canceled the feeling.";
            } else {
                // 현재 감정에서 다른 감정으로 변경하는 경우
                existingRating.setFeeling(requestDto.getFeeling());
                rateRepository.save(existingRating);
                return "Changed feeling.";
            }
        } else {
            //선택된 감정이 없을 때
            Rating newRating = requestDto.to(review, user);
            rateRepository.save(newRating);
            return "Save Rating.";
        }

    }
}
