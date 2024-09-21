package com.example.knu_mingle.service;

import com.example.knu_mingle.domain.Image;
import com.example.knu_mingle.domain.Market;
import com.example.knu_mingle.domain.Review;
import com.example.knu_mingle.repository.ImageRepository;
import com.example.knu_mingle.repository.MarketRepository;
import com.example.knu_mingle.repository.ReviewRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;

@Service
public class ImageService {
    @Autowired
    private ImageRepository imageRepository;
    @Autowired
    private ReviewRepository reviewRepository;
    @Autowired
    private MarketRepository marketRepository;

    public Image createMarketImage(Market market, List<String> images) {

        Image image = new Image();
        image.setReview(reviewRepository.getById(1L)); // 더미 리뷰
        image.setMarket(market); // Market 객체 설정
        image.setPath(images); // 이미지 경로

        return imageRepository.save(image);
    }

    public void updateMarketImage(Market market, List<String> images) {
        Image existingImage = imageRepository.findByMarket(market);
        existingImage.setPath(images);
        imageRepository.save(existingImage);
    }

    public Image getImageByMarket(Market market) {
        return (Image) imageRepository.findByMarket(market);
    }

    public Image createReviewImage(Review review, List<String> images) {
        Image image = new Image();
        image.setReview(review);
        image.setPath(images);
        image.setMarket(marketRepository.getById(1L));
        // 이미지 리스트를 데이터베이스에 저장
        return imageRepository.save(image);
    }

    public void updateReviewImage(Review review, List<String> images) {
        // 기존 이미지 리스트를 가져옴
        Image existingImage = imageRepository.findByReview(review);
        existingImage.setPath(images);

        // 모든 변경 사항을 데이터베이스에 저장합니다.
        imageRepository.save(existingImage);
    }

    public Image getImageByReview(Review review) {
        return imageRepository.findByReview(review);
    }
}
