package com.example.knu_mingle.controller;

import com.example.knu_mingle.domain.Market;
import com.example.knu_mingle.dto.MarketRequestDto;
import com.example.knu_mingle.dto.MarketUpdateDto;
import com.example.knu_mingle.service.MarketService;
import io.swagger.v3.oas.annotations.Operation;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpHeaders;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.parameters.P;
import org.springframework.web.bind.annotation.*;

@org.springframework.web.bind.annotation.RestController
@RequestMapping("/market")
public class MarketRestController {

    @Autowired
    private MarketService marketService;

    @Operation(summary = "중고거래 게시글 작성")
    @PostMapping()
    public ResponseEntity<Object> createMarket(@RequestHeader(HttpHeaders.AUTHORIZATION) String accessToken, @RequestBody MarketRequestDto market) {
        return ResponseEntity.status(201).body(marketService.createMarket(accessToken, market));
    }

    @Operation(summary = "중고거래 게시글 수정")
    @PutMapping("/{market_id}")
    public ResponseEntity<Object> updateMarket(@RequestHeader(HttpHeaders.AUTHORIZATION) String accessToken, @PathVariable Long market_id, @RequestBody MarketUpdateDto updateDto) {
        return ResponseEntity.ok(marketService.updateMarket(accessToken, market_id, updateDto));
    }
}
