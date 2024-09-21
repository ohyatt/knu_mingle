package com.example.knu_mingle.dto;

import com.example.knu_mingle.domain.Enum.Status;
import com.example.knu_mingle.domain.Market;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class MarketUpdateDto {
    private String title;
    private String content;
    private String method;
    private Status status;

    public Market update(Market market) {
        market.setTitle(title);
        market.setContent(content);
        market.setMethod(method);
        market.setStatus(status);
        return market;
    }
}
