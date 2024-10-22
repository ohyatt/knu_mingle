package com.example.knu_mingle.repository;

import com.example.knu_mingle.domain.Image;
import com.example.knu_mingle.domain.Market;
import com.example.knu_mingle.domain.Review;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface ImageRepository extends JpaRepository<Image, Long> {
   Image findByMarket(Market market);
   Image findByReview(Review review);
}
