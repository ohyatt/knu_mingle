package com.example.knu_mingle.service;

import com.example.knu_mingle.domain.Keyword;
import com.example.knu_mingle.domain.Market;
import com.example.knu_mingle.domain.Review;
import com.example.knu_mingle.domain.User;
import com.example.knu_mingle.dto.MarketRequestDto;
import com.example.knu_mingle.dto.ReviewRequestDto;
import com.example.knu_mingle.repository.ReviewRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.NoSuchElementException;

@Service
public class ReviewService {
    @Autowired
    private ReviewRepository reviewRepository;
    private UserService userService;
    private JwtService jwtService;

    public String createReview(String accessToken, ReviewRequestDto requestDto) {
        String email = jwtService.getEmailFromToken(accessToken);
        User user = userService.getUserByEmail(email);

        Review review = new Review();
        reviewRepository.save(review);
        return "Success";
    }

    public List<Review> getAllReviews() {
        return reviewRepository.findAll();
    }

    public List<Review> getReviewsByKeyword(String keyword) {
        return reviewRepository.findByKeyword(keyword);
    }

    public String updateReview(String accessToken, Long reviewId, ReviewRequestDto requestDto) {
        String email = jwtService.getEmailFromToken(accessToken);
        User user = userService.getUserByEmail(email).orElseThrow(() -> new RuntimeException("User not found"));

        Review review = reviewRepository.findById(reviewId)
                .orElseThrow(() -> new RuntimeException("Review not found"));

        reviewRepository.save(review);
        return "Success";
    }

    public String deleteReview(String accessToken, Long reviewId) {
        String email = jwtService.getEmailFromToken(accessToken);
        User user = userService.getUserByEmail(email).
                orElseThrow(() -> new RuntimeException("User not found"));

        Review review = reviewRepository.findById(reviewId)
                .orElseThrow(() -> new RuntimeException("Review not found"));

        reviewRepository.delete(review);
        return "Review Deleted";
    }
}
