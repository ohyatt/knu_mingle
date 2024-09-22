package com.example.knu_mingle.dto;

import com.example.knu_mingle.domain.Location;
import com.google.maps.model.LatLng;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class LocationDataDto {
    private Long id;
    private String name;
    private String address;
    private String sector;
    private String phoneNumber;
    private String language;
    private double latitude;
    private double longitude;

    public LocationDataDto(Location location, LatLng location1) {
        this.id = location.getId();
        this.name = location.getName();
        this.address = location.getAddress();
        this.sector = location.getSector();
        this.phoneNumber = location.getPhoneNumber();
        this.language = location.getLanguage();
        this.latitude = location1.lat;
        this.longitude = location1.lng;
    }
}
