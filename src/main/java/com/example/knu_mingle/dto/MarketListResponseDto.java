package com.example.knu_mingle.dto;

import com.example.knu_mingle.domain.Enum.Status;
import com.example.knu_mingle.domain.Market;
import com.example.knu_mingle.domain.User;
import lombok.Getter;
import lombok.Setter;

import java.time.LocalDateTime;

@Setter
@Getter
public class MarketListResponseDto {
    private Long id;
    private MarketUserInfoDto user;
    private String title;
    private Status status;
    private LocalDateTime createdAt;
    private LocalDateTime modifiedAt;

    public MarketListResponseDto(Market market) {
        this.id = market.getId();
        this.user = new MarketUserInfoDto(market.getUser());
        this.status = market.getStatus();
        this.title = market.getTitle();
        this.createdAt = market.getCreatedAt();
        this.modifiedAt = market.getModifiedAt();
    }
}
