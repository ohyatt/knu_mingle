package com.example.knu_mingle.repository;

import com.example.knu_mingle.domain.Market;
import com.example.knu_mingle.domain.MarketImage;
import org.springframework.data.jpa.repository.JpaRepository;

public interface MarketImageRepository extends JpaRepository<MarketImage, Long> {
    MarketImage findByMarket(Market market);
}
