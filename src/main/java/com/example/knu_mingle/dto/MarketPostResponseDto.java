package com.example.knu_mingle.dto;

import com.example.knu_mingle.domain.Enum.Status;
import com.example.knu_mingle.domain.Market;
import com.example.knu_mingle.domain.MarketImage;
import lombok.Getter;
import lombok.Setter;

import java.time.LocalDateTime;
import java.util.List;

@Setter
@Getter
public class MarketPostResponseDto {

    private MarketUserInfoDto userInfoDto;
    private String title;
    private String content;
    private Status status;
    private String method;
    private LocalDateTime createdAt;
    private LocalDateTime modifiedAt;
    private List<String> imageUrl;

    public MarketPostResponseDto(Market market, MarketImage image) {
        this.userInfoDto = new MarketUserInfoDto(market.getUser());
        this.title = market.getTitle();
        this.content = market.getContent();
        this.status = market.getStatus();
        this.method = market.getMethod();
        this.createdAt = market.getCreatedAt();
        this.modifiedAt = market.getModifiedAt();
        this.imageUrl = image.getPath();
    }
}
