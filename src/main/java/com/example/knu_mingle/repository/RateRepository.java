package com.example.knu_mingle.repository;

import com.example.knu_mingle.domain.Enum.Feeling;
import com.example.knu_mingle.domain.Rating;
import com.example.knu_mingle.domain.Review;
import com.example.knu_mingle.domain.User;
import com.example.knu_mingle.dto.ReviewPostResponseDto;
import com.example.knu_mingle.dto.ReviewRequestDto;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface RateRepository extends JpaRepository<Rating, Long> {

    Rating findByReviewAndUser(Review review, User user);
}
