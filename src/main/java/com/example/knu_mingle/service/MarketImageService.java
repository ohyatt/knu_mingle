package com.example.knu_mingle.service;

import com.example.knu_mingle.domain.Image;
import com.example.knu_mingle.domain.Market;
import com.example.knu_mingle.domain.MarketImage;
import com.example.knu_mingle.repository.ImageRepository;
import com.example.knu_mingle.repository.MarketImageRepository;
import com.example.knu_mingle.repository.MarketRepository;
import com.example.knu_mingle.repository.ReviewRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class MarketImageService {
    @Autowired
    private MarketImageRepository marketImageRepository;

    public MarketImage createMarketImage(Market market, List<String> images) {

        MarketImage marketImage = new MarketImage();
        marketImage.setMarket(market); // Market 객체 설정
        marketImage.setPath(images); // 이미지 경로

        return marketImageRepository.save(marketImage);
    }

    public void updateMarketImage(Market market, List<String> images) {
        MarketImage existingImage = marketImageRepository.findByMarket(market);
        if (existingImage != null) {
            existingImage.setPath(images);
            marketImageRepository.save(existingImage);
        }
        else{
            marketImageRepository.save(createMarketImage(market, images));
        }
    }

    public MarketImage getImageByMarket(Market market) {
        return marketImageRepository.findByMarket(market);
    }


}
