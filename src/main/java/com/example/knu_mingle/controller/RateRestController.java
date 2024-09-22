package com.example.knu_mingle.controller;

import com.example.knu_mingle.domain.Enum.Feeling;
import com.example.knu_mingle.dto.RateRequestDto;
import com.example.knu_mingle.dto.ReviewRequestDto;
import com.example.knu_mingle.service.RateService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpHeaders;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.Map;

@RestController
@RequestMapping("/ratings")
public class RateRestController {

    @Autowired
    RateService rateService;

    @PostMapping("/{id}")
    public ResponseEntity<Object> rateReview(@RequestHeader(HttpHeaders.AUTHORIZATION) String accessToken, @PathVariable Long id, @RequestBody RateRequestDto requestDto) {
        return ResponseEntity.status(201).body(rateService.rateReview(accessToken, id, requestDto));
    }

    //@GetMapping("/{id}")
    //리뷰 id인 PathVariable id 값으로 해당 리뷰에 feeling(좋아요와 싫어요 각각) 갯수 합산해서 보내줘야 함

    @GetMapping("/{id}")
    public ResponseEntity<Object> getReviewFeelings(@PathVariable Long id) {
        int likeCount = rateService.getLikeCountByReviewId(id);
        int dislikeCount = rateService.getDislikeCountByReviewId(id);

        Map<String, Integer> response = new HashMap<>();
        response.put("likes", likeCount);
        response.put("dislikes", dislikeCount);

        return ResponseEntity.ok(response); // 200 OK
    }
}
