package com.example.knu_mingle.service;

import com.example.knu_mingle.domain.Location;
import com.example.knu_mingle.dto.LocationDataDto;
import com.example.knu_mingle.repository.LocationRepository;
import com.google.maps.GeoApiContext;
import com.google.maps.GeocodingApi;
import com.google.maps.errors.ApiException;
import com.google.maps.model.GeocodingResult;
import com.google.maps.model.LatLng;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

@Service
public class LocationService {
    @Autowired
    private LocationRepository locationRepository;

    @Value("${google.api.key}")
    private String apiKey;

    public static final double EARTH_RADIUS = 6371.0088; // 지구 반지름 상수 선언

    public List<LocationDataDto> getAllLocation() throws IOException, InterruptedException, ApiException {
        List<Location> locations = locationRepository.findAll();
        List<LocationDataDto> locationDataDtos = new ArrayList<>();
        for (Location location : locations) {
            LocationDataDto locationDataDto = new LocationDataDto(location, getLocation(location.getAddress()));
            locationDataDtos.add(locationDataDto);
        }
        return locationDataDtos;
    }

    // 주소 가지고 위도 경도 구하기
    public LatLng getLocation(String address) throws IOException, InterruptedException, ApiException {
        if(address.equals("")){
            return null;
        }
        GeoApiContext context = new GeoApiContext.Builder().apiKey(apiKey).build();
        GeocodingResult[] results = GeocodingApi.geocode(context, address).await();
        if(results.length != 0){
            LatLng location = results[0].geometry.location;
            return location;
        }
        return null;
    }

}
