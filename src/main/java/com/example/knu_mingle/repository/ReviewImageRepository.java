package com.example.knu_mingle.repository;

import com.example.knu_mingle.domain.Review;
import com.example.knu_mingle.domain.ReviewImage;
import org.springframework.data.jpa.repository.JpaRepository;

public interface ReviewImageRepository extends JpaRepository<ReviewImage, Long> {
    ReviewImage findByReview(Review review);
}
