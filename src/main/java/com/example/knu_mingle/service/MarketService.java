package com.example.knu_mingle.service;

import com.example.knu_mingle.domain.Market;
import com.example.knu_mingle.domain.User;
import com.example.knu_mingle.dto.MarketRequestDto;
import com.example.knu_mingle.dto.MarketUpdateDto;
import com.example.knu_mingle.repository.MarketRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class MarketService {
    @Autowired
    private MarketRepository marketRepository;
    private UserService userService;
    private JwtService jwtService;

    public String createMarket(String accessToken, MarketRequestDto requestDto) {
        User user = userService.getUserByToken(accessToken);
        Market market = requestDto.to(user);
        marketRepository.save(market);
        return "Success";
    }

    public Object updateMarket(String accessToken, Long market_id, MarketUpdateDto updateDto) {
        User user = userService.getUserByToken(accessToken);
        Market market = marketRepository.getById(market_id);

        marketRepository.save(updateDto.update(market));
        return "Success";
    }
}
