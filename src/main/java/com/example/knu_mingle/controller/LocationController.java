package com.example.knu_mingle.controller;

import com.example.knu_mingle.dto.LocationDataDto;
import com.example.knu_mingle.service.LocationService;
import com.google.maps.errors.ApiException;
import io.swagger.v3.oas.annotations.Operation;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.io.IOException;
import java.util.List;

@RestController
@RequestMapping("/maps")
public class LocationController {
    @Autowired
    private LocationService locationService;

    @Operation(summary = "병원 장소 가져오기")
    @GetMapping
    public List<LocationDataDto> getAllLocations() throws IOException, InterruptedException, ApiException {
        return locationService.getAllLocation();
    }
}
