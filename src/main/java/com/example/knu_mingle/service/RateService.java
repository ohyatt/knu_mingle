package com.example.knu_mingle.service;

import com.example.knu_mingle.domain.Enum.Feeling;
import com.example.knu_mingle.domain.Rating;
import com.example.knu_mingle.domain.Review;
import com.example.knu_mingle.domain.User;
import com.example.knu_mingle.dto.RateRequestDto;
import com.example.knu_mingle.dto.ReviewRequestDto;
import com.example.knu_mingle.repository.RateRepository;
import com.example.knu_mingle.repository.ReviewRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpHeaders;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestHeader;

public class RateService {

    @Autowired
    private RateRepository rateRepository;
    @Autowired
    private ReviewRepository reviewRepository;
    private UserService userService;
    private JwtService jwtService;


    public String rateReview(String accessToken, Long id, RateRequestDto requestDto) {
        User user = userService.getUserByToken(accessToken);
        Review review = reviewRepository.getById(id);

        Rating rating = requestDto.to(review, user);
        rateRepository.save(rating);
        return "Success";
    }
}
