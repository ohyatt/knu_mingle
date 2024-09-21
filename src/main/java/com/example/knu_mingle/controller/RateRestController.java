package com.example.knu_mingle.controller;

import com.example.knu_mingle.domain.Enum.Feeling;
import com.example.knu_mingle.dto.RateRequestDto;
import com.example.knu_mingle.dto.ReviewRequestDto;
import com.example.knu_mingle.service.RateService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpHeaders;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/ratings")
public class RateRestController {

    @Autowired
    RateService rateService;

    @PostMapping("/{id}")
    public ResponseEntity<Object> rateReview(@RequestHeader(HttpHeaders.AUTHORIZATION) String accessToken, @PathVariable Long id, RateRequestDto requestDto) {
        return ResponseEntity.status(201).body(rateService.rateReview(accessToken, id, requestDto));
    }



}
