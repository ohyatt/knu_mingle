package com.example.knu_mingle.service;

import com.example.knu_mingle.domain.Enum.Keyword;
import com.example.knu_mingle.domain.Enum.Reaction;
import com.example.knu_mingle.domain.Market;
import com.example.knu_mingle.domain.Rating;
import com.example.knu_mingle.domain.Review;
import com.example.knu_mingle.domain.User;
import com.example.knu_mingle.dto.*;
import com.example.knu_mingle.repository.ReviewRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class ReviewService {
    @Autowired
    private ReviewRepository reviewRepository;
    private UserService userService;
    private JwtService jwtService;

    public List<Review> getAllReviews() {
        return reviewRepository.findAll();
    }

    public List<Review> getReviewsByKeyword(Keyword keyword) {

        return reviewRepository.findByKeyword(keyword);
    }

    public String createReview(String accessToken, ReviewRequestDto requestDto) {
        User user = userService.getUserByToken(accessToken);
        Review review = requestDto.to(user);
        reviewRepository.save(review);
        return "Success";
    }

    public String updateReview(String accessToken, Long reviewId, ReviewUpdateDto updateDto) {
        User user = userService.getUserByToken(accessToken);
        Review review = reviewRepository.getById(reviewId);

        reviewRepository.save(updateDto.update(review));
        return "Review Updated";
    }

    public String deleteReview(String accessToken, Long reviewId) {
        User user = userService.getUserByToken(accessToken);
        Review review = reviewRepository.getById(reviewId);

        reviewRepository.delete(review);
        return "Review Deleted";
    }
}
