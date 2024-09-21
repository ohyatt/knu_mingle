package com.example.knu_mingle.dto;

import com.example.knu_mingle.domain.Market;
import com.example.knu_mingle.domain.User;
import lombok.Getter;
import lombok.Setter;

@Setter
@Getter
public class MarketRequestDto {
    private String title;
    private String content;
    private String method;

    public Market to(User user) {
        Market market = new Market();
        market.setContent(this.content);
        market.setTitle(this.title);
        market.setMethod(this.method);
        market.setUser(user);
        return market;
    }
}
