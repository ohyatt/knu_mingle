package com.example.knu_mingle.dto;

import com.example.knu_mingle.domain.Enum.Status;
import com.example.knu_mingle.domain.Market;
import lombok.Getter;
import lombok.Setter;

import java.time.LocalDateTime;

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

    public MarketPostResponseDto(Market market) {
        this.userInfoDto = new MarketUserInfoDto(market.getUser());
        this.title = market.getTitle();
        this.content = market.getContent();
        this.status = market.getStatus();
        this.method = market.getMethod();
        this.createdAt = market.getCreatedAt();
        this.modifiedAt = market.getModifiedAt();
    }
}
