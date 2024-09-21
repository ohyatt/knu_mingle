package com.example.knu_mingle.controller;


import com.example.knu_mingle.domain.Enum.Keyword;
import com.example.knu_mingle.domain.Review;
import com.example.knu_mingle.domain.User;
import com.example.knu_mingle.dto.MarketRequestDto;
import com.example.knu_mingle.dto.ReviewPostResponseDto;
import com.example.knu_mingle.dto.ReviewRequestDto;
import com.example.knu_mingle.dto.ReviewUpdateDto;
import com.example.knu_mingle.service.ReviewService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/review")
public class ReviewRestController {

    @Autowired
    private ReviewService reviewService;

    @GetMapping
    public ResponseEntity<List<ReviewPostResponseDto>> getAllReviews(@RequestHeader(HttpHeaders.AUTHORIZATION) String accessToken) {
        return ResponseEntity.ok(reviewService.getAllReviews(accessToken));
    }

    @GetMapping("/{keyword}")
    public ResponseEntity<List<ReviewPostResponseDto>> getReviewsByKeyword(@RequestHeader(HttpHeaders.AUTHORIZATION) String accessToken, @PathVariable Keyword keyword) {
        List<ReviewPostResponseDto> reviews = reviewService.getReviewsByKeyword(accessToken, keyword);
        if (reviews.isEmpty()) {
            return new ResponseEntity<>(HttpStatus.NO_CONTENT); // 204 No Content
        }
        return new ResponseEntity<>(reviews, HttpStatus.OK); // 200 OK
    }

    //리뷰 생성
    @PostMapping
    public ResponseEntity<Object> createReview(@RequestHeader(HttpHeaders.AUTHORIZATION) String accessToken, @RequestBody ReviewRequestDto review) {
        return ResponseEntity.status(201).body(reviewService.createReview(accessToken, review));
    }

    //리뷰 수정
    @PutMapping ("/{id}")
    public ResponseEntity<Object> updateReview(@RequestHeader(HttpHeaders.AUTHORIZATION) String accessToken, @PathVariable Long id, @RequestBody ReviewUpdateDto review) {
        return ResponseEntity.status(201).body(reviewService.updateReview(accessToken, id, review));
    }

    //리뷰 삭제
    @DeleteMapping("/{id}")
    public ResponseEntity<Object> deleteReview(@RequestHeader(HttpHeaders.AUTHORIZATION) String accessToken, @PathVariable Long id) {
        return ResponseEntity.ok(reviewService.deleteReview(accessToken, id));
    }

    //리뷰 조회
    @GetMapping("/{id}")
    public ResponseEntity<Object> getReview(@RequestHeader(HttpHeaders.AUTHORIZATION) String accessToken, @PathVariable Long id) {
        return ResponseEntity.ok(reviewService.getReview(accessToken,id));
    }
}
