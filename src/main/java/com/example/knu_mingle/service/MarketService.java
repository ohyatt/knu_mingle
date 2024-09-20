package com.example.knu_mingle.service;

import com.example.knu_mingle.domain.Market;
import com.example.knu_mingle.domain.User;
import com.example.knu_mingle.dto.MarketRequestDto;
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
        String email = jwtService.getEmailFromToken(accessToken);
        User user = userService.getUserByEmail(email).orElseThrow();
        Market market = new Market();
        marketRepository.save(market);
        return "Success";
    }
}
