package com.example.knu_mingle.service;

import com.example.knu_mingle.domain.Market;
import com.example.knu_mingle.domain.User;
import com.example.knu_mingle.dto.MarketListResponseDto;
import com.example.knu_mingle.dto.MarketPostResponseDto;
import com.example.knu_mingle.dto.MarketRequestDto;
import com.example.knu_mingle.dto.MarketUpdateDto;
import com.example.knu_mingle.repository.MarketRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.web.server.ResponseStatusException;

import java.util.List;
import java.util.stream.Collectors;

@Service
public class MarketService {
    @Autowired
    private MarketRepository marketRepository;
    @Autowired
    private UserService userService;
    @Autowired
    private JwtService jwtService;
    @Autowired
    private ImageService imageService;

    public String createMarket(String accessToken, MarketRequestDto requestDto) {
        User user = userService.getUserByToken(accessToken);
        Market market = requestDto.to(user);
        imageService.createMarketImage(market, requestDto.getImages()); // 이미지 저장 로직
        marketRepository.save(market);
        return "Success";
    }

    public Object updateMarket(String accessToken, Long market_id, MarketUpdateDto updateDto) {
        User user = userService.getUserByToken(accessToken);
        Market market = marketRepository.getById(market_id);
        imageService.updateMarketImage(market, updateDto.getImages()); // 이미지 업데이트 로직
        marketRepository.save(updateDto.update(market));
        return "Success";
    }

    public MarketPostResponseDto getMarket(String accessToken, Long marketId) {
        User user = userService.getUserByToken(accessToken);
        Market market = marketRepository.getById(marketId);
        return new MarketPostResponseDto(market);
    }

    public List<MarketListResponseDto> getMarketList(String accessToken) {
        User user = userService.getUserByToken(accessToken);
        List<Market> markets = marketRepository.findAll();

        return markets.stream()
                .map(MarketListResponseDto::new)
                .collect(Collectors.toList());
    }

    public Object deleteMarket(String accessToken, Long marketId) {
        User user = userService.getUserByToken(accessToken);
        // 게시글 조회
        Market market = marketRepository.findById(marketId)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Market not found with id: " + marketId));

        // 사용자 확인
        if (user.getId().equals(market.getUser().getId())) {
            marketRepository.deleteById(marketId);
            return "Success";
        } else {
            throw new ResponseStatusException(HttpStatus.FORBIDDEN, "You do not have permission to delete this market.");
        }

    }

    public Market getMarketById(Long marketId) {
        return marketRepository.getById(marketId);
    }
}
