package com.example.knu_mingle.controller;

import com.example.knu_mingle.domain.Location;
import com.example.knu_mingle.service.LocationService;
import io.swagger.v3.oas.annotations.Operation;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
@RequestMapping("/maps")
public class LocationController {
    @Autowired
    private LocationService locationService;

    @Operation(summary = "병원 장소 가져오기")
    @GetMapping
    public List<Location> getAllLocations(){
        return locationService.getAllLocation();
    }
}
