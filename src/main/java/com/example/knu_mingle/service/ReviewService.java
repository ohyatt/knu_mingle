package com.example.knu_mingle.service;

import com.example.knu_mingle.domain.Keyword;
import com.example.knu_mingle.domain.Market;
import com.example.knu_mingle.domain.Review;
import com.example.knu_mingle.domain.User;
import com.example.knu_mingle.dto.ReviewRequestDto;
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

    public String createReview(String accessToken, ReviewRequestDto requestDto) {
        String email = jwtService.getEmailFromToken(accessToken);
        User user = userService.getUserByEmail(email).orElseThrow();

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

        Review updatedReview = new Review(
                review.getUser(), // 기존 사용자 정보 유지
                Keyword.valueOf(requestDto.getKeyword().toUpperCase()),
                requestDto.getTitle(),
                requestDto.getContent(),
                requestDto.getReaction()
        );

        reviewRepository.save(updatedReview);
        return "Success";
    }

    public String deleteReview(String accessToken, Long reviewId) {
        String email = jwtService.getEmailFromToken(accessToken);
        User user = userService.getUserByEmail(email).orElseThrow(() -> new RuntimeException("User not found"));

        Review review = reviewRepository.findById(reviewId)
                .orElseThrow(() -> new RuntimeException("Review not found"));

        if (!review.getUser().getId().equals(user.getId())) {
            throw new RuntimeException("You are not authorized to delete this review");
        }

        reviewRepository.delete(review);
        return "Success";
    }
}
