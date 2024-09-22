package com.example.knu_mingle.service;

import com.example.knu_mingle.domain.Review;
import com.example.knu_mingle.domain.ReviewImage;
import com.example.knu_mingle.repository.ReviewImageRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class ReviewImageService {
    @Autowired
    private ReviewImageRepository reviewImageRepository;

    public ReviewImage createReviewImage(Review review, List<String> images) {
        ReviewImage image = new ReviewImage();
        image.setReview(review);
        image.setPath(images);
        reviewImageRepository.save(image);
        return image;
    }

    public void updateReviewImage(Review review, List<String> images) {
        // 기존 이미지 리스트를 가져옴
        ReviewImage existingImage = reviewImageRepository.findByReview(review);
        existingImage.setPath(images);
        reviewImageRepository.save(existingImage);
    }

    public ReviewImage getImageByReview(Review review) {
        return reviewImageRepository.findByReview(review);
    }
}
