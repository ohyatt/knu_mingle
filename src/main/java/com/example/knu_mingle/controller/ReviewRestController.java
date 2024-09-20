package com.example.knu_mingle.controller;


import com.example.knu_mingle.domain.Review;
import com.example.knu_mingle.domain.User;
import com.example.knu_mingle.service.ReviewService;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/review")
public class ReviewRestController {

    ReviewService reviewService;

    public ReviewRestController(ReviewService reviewService) {
        this.reviewService = reviewService;
    }

    @GetMapping
    public ResponseEntity<List<Review>> getAllReviews() {
        List<Review> reviews = reviewService.getAllReviews();
        return new ResponseEntity<>(reviews, HttpStatus.OK); // 200 OK와 함께 리뷰 목록 반환
    }

    @GetMapping("/{keyword}")
    public ResponseEntity<List<Review>> getReviewsByKeyword(@PathVariable String keyword) {
        List<Review> reviews = reviewService.getReviewsByKeyword(keyword);
        if (reviews.isEmpty()) {
            return new ResponseEntity<>(HttpStatus.NO_CONTENT); // 204 No Content
        }
        return new ResponseEntity<>(reviews, HttpStatus.OK); // 200 OK
    }

    // 리뷰 작성
    @PostMapping
    public ResponseEntity<Review> createReview(@RequestBody Review review) {
        reviewService.createReview(review);
        return new ResponseEntity<>(HttpStatus.CREATED); // 201 Created
    }

    // 리뷰 수정
    @PutMapping ("/{id}")
    public ResponseEntity<Review> updateReview(@PathVariable Long id, @RequestBody Review review) {
        Review updatedReview = reviewService.updateReview(review);
        return new ResponseEntity<>(HttpStatus.OK); // 200 OK
    }









}
