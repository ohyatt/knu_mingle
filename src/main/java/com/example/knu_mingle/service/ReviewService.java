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
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.web.server.ResponseStatusException;

import java.util.List;

@Service
public class ReviewService {
    @Autowired
    private ReviewRepository reviewRepository;
    @Autowired
    private UserService userService;
    @Autowired
    private JwtService jwtService;

    public Review getReview(Long id) {
        //User user = userService.getUserByToken(accessToken);
        return reviewRepository.getById(id);
    }

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

    public Object deleteReview(String accessToken, Long reviewId) {
        User user = userService.getUserByToken(accessToken);
        //리뷰 조회
        Review review = reviewRepository.findById(reviewId)
                        .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Review not found with id: " + reviewId));

        if(user.getId().equals(review.getUser().getId())) {
            reviewRepository.delete(review);
            return "Review Deleted";
        }
        else {
            throw new ResponseStatusException(HttpStatus.FORBIDDEN, "You do not have permission to delete this review.");
        }
    }
}
