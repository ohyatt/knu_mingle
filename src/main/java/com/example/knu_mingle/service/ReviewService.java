package com.example.knu_mingle.service;

import com.example.knu_mingle.domain.*;
import com.example.knu_mingle.domain.Enum.Keyword;
import com.example.knu_mingle.dto.*;
import com.example.knu_mingle.repository.ReviewRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.web.server.ResponseStatusException;

import java.util.ArrayList;
import java.util.List;

@Service
public class ReviewService {
    @Autowired
    private ReviewRepository reviewRepository;
    @Autowired
    private UserService userService;
    @Autowired
    private JwtService jwtService;
    @Autowired
    private ReviewImageService reviewImageService;

    public ReviewPostResponseDto getReview(String accessToken, Long id) {
        User user = userService.getUserByToken(accessToken);
        Review review = reviewRepository.getById(id);
        ReviewImage image = reviewImageService.getImageByReview(review);
        return new ReviewPostResponseDto(review, image.getPath());
    }

    public List<ReviewPostResponseDto> getAllReviews(String accessToken) {
        User user = userService.getUserByToken(accessToken);
        List<Review> reviews = reviewRepository.findAll();

        List<ReviewPostResponseDto> responseDtos = new ArrayList<>();
        for (Review review : reviews) {
            if(!review.getTitle().equals("deleted")){
                ReviewImage image = reviewImageService.getImageByReview(review);
                ReviewPostResponseDto responseDto = new ReviewPostResponseDto(review, image.getPath());
                responseDtos.add(responseDto);
            }
        }

        return responseDtos;
    }

    public List<ReviewPostResponseDto> getReviewsByKeyword(String accessToken, Keyword keyword) {
        User user = userService.getUserByToken(accessToken);
        List<Review> reviews = reviewRepository.findByKeyword(keyword);

        List<ReviewPostResponseDto> responseDtos = new ArrayList<>();
        for (Review review : reviews) {
            if(!review.getTitle().equals("deleted")){
                ReviewImage image = reviewImageService.getImageByReview(review);
                ReviewPostResponseDto responseDto = new ReviewPostResponseDto(review, image.getPath());
                responseDtos.add(responseDto);
            }
        }

        return responseDtos;
    }

    public String createReview(String accessToken, ReviewRequestDto requestDto) {
        User user = userService.getUserByToken(accessToken);
        Review review = requestDto.to(user);
        reviewRepository.save(review);
        reviewImageService.createReviewImage(review,requestDto.getImages());
        return "Success";
    }

    public String updateReview(String accessToken, Long reviewId, ReviewUpdateDto updateDto) {
        User user = userService.getUserByToken(accessToken);
        Review review = reviewRepository.getById(reviewId);

        reviewRepository.save(updateDto.update(review));
        reviewImageService.updateReviewImage(review,updateDto.getImages());
        return "Review Updated";
    }

    public Object deleteReview(String accessToken, Long reviewId) {
        User user = userService.getUserByToken(accessToken);
        //리뷰 조회
        Review review = reviewRepository.findById(reviewId)
                        .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Review not found with id: " + reviewId));

        if(user.getId().equals(review.getUser().getId())) {
            review.setTitle("deleted");
            reviewRepository.save(review);
            return "Review Deleted";
        }
        else {
            throw new ResponseStatusException(HttpStatus.FORBIDDEN, "You do not have permission to delete this review.");
        }
    }
}
