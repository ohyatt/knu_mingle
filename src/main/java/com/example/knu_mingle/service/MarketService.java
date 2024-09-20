package com.example.knu_mingle.service;

import com.example.knu_mingle.domain.Market;
import com.example.knu_mingle.repository.MarketRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class MarketService {
    @Autowired
    private MarketRepository marketRepository;

    public Market createMarket(Market market) {
        return marketRepository.save(market);
    }
}
