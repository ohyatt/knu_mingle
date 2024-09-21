package com.example.knu_mingle.service;

import com.example.knu_mingle.domain.Image;
import com.example.knu_mingle.domain.Market;
import com.example.knu_mingle.domain.Review;
import com.example.knu_mingle.dto.ImageDto;
import com.example.knu_mingle.repository.ImageRepository;
import com.example.knu_mingle.repository.ReviewRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
public class ImageService {
    @Autowired
    private ImageRepository imageRepository;
    @Autowired
    private ReviewRepository reviewRepository;

    public List<Image> createMarketImage(Market market, List<String> images) {
        List<Image> imageList = new ArrayList<>();

        for (String imagePath : images) {
            Image image = new Image();
            image.setReview(reviewRepository.getById(1L)); // 더미 리뷰
            image.setMarket(market); // Market 객체 설정
            image.setPath(imagePath); // 이미지 경로 설정
            imageList.add(image); // 리스트에 추가
        }

        // 이미지 리스트를 데이터베이스에 저장
        return imageRepository.saveAll(imageList);
    }

    public void updateMarketImage(Market market, List<ImageDto> images) {
        // 기존 이미지 리스트를 가져옴
        List<Image> existingImages = imageRepository.findByMarket(market);

        // existingImages를 Map으로 변환하여 imageId로 접근 가능
        Map<Long, Image> existingImageMap = new HashMap<>();
        for (Image existingImage : existingImages) {
            existingImageMap.put(existingImage.getId(), existingImage);
        }

        // images 리스트를 순회하며 업데이트합니다.
        for (ImageDto imageDto : images) {
            Image existingImage = existingImageMap.get(imageDto.getImageId());
            if (existingImage != null) {
                // 이미지 경로 업데이트
                existingImage.setPath(imageDto.getImageUrl());
            } else {
                // 새로운 이미지 추가 (필요시)
                Image newImage = new Image();
                newImage.setMarket(market); // 마켓 설정
                newImage.setPath(imageDto.getImageUrl()); // 이미지 경로 설정
                // 더미 리뷰 설정 (필요시)
                // newImage.setReview(dummyReview);
                existingImages.add(newImage); // 리스트에 추가
            }
        }

        // 기존 이미지 중 images에 없는 것은 삭제 처리
        for (Image existingImage : existingImages) {
            boolean existsInDto = images.stream().anyMatch(dto -> dto.getImageId().equals(existingImage.getId()));
            if (!existsInDto) {
                imageRepository.delete(existingImage); // 삭제
            }
        }

        // 모든 변경 사항을 데이터베이스에 저장합니다.
        imageRepository.saveAll(existingImages);
    }

    public List<Image> getImageByMarket(Market market) {
        return imageRepository.findByMarket(market);
    }

    public List<Image> createReviewImage(Review review, List<String> images) {
        List<Image> imageList = new ArrayList<>();

        for (String imagePath : images) {
            Image image = new Image();
            //image.setReview(); // 더미 리뷰
            image.setReview(review); // Review 객체 설정
            image.setPath(imagePath); // 이미지 경로 설정
            imageList.add(image); // 리스트에 추가
        }

        // 이미지 리스트를 데이터베이스에 저장
        return imageRepository.saveAll(imageList);
    }

    public void updateReviewImage(Review review, List<ImageDto> images) {
        // 기존 이미지 리스트를 가져옴
        List<Image> existingImages = imageRepository.findByReview(review);

        // existingImages를 Map으로 변환하여 imageId로 접근 가능
        Map<Long, Image> existingImageMap = new HashMap<>();
        for (Image existingImage : existingImages) {
            existingImageMap.put(existingImage.getId(), existingImage);
        }

        // images 리스트를 순회하며 업데이트합니다.
        for (ImageDto imageDto : images) {
            Image existingImage = existingImageMap.get(imageDto.getImageId());
            if (existingImage != null) {
                // 이미지 경로 업데이트
                existingImage.setPath(imageDto.getImageUrl());
            } else {
                // 새로운 이미지 추가 (필요시)
                Image newImage = new Image();
                newImage.setReview(review); // 리뷰 설정
                newImage.setPath(imageDto.getImageUrl()); // 이미지 경로 설정
                // 더미 리뷰 설정 (필요시)
                // newImage.setReview(dummyReview);
                existingImages.add(newImage); // 리스트에 추가
            }
        }

        // 기존 이미지 중 images에 없는 것은 삭제 처리
        for (Image existingImage : existingImages) {
            boolean existsInDto = images.stream().anyMatch(dto -> dto.getImageId().equals(existingImage.getId()));
            if (!existsInDto) {
                imageRepository.delete(existingImage); // 삭제
            }
        }

        // 모든 변경 사항을 데이터베이스에 저장합니다.
        imageRepository.saveAll(existingImages);
    }

    public List<Image> getImageByReview(Review review) {
        return imageRepository.findByReview(review);
    }
}
