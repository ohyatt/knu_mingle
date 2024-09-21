package com.example.knu_mingle.service;

import com.example.knu_mingle.domain.Enum.Faculty;
import com.example.knu_mingle.domain.Enum.Nation;
import org.springframework.stereotype.Service;

import java.util.Arrays;
import java.util.List;
import java.util.stream.Collectors;

@Service
public class ListService {

    public List<String> getNations() {
        return Arrays.stream(Nation.values())
                .map(nation -> nation.name().replace("_", " ")) // 언더스코어를 공백으로 변환
                .collect(Collectors.toList());
    }

    public List<String> getFaculties() {
        return Arrays.stream(Faculty.values())
                .map(faculty -> faculty.name().replace("_", " ")) // 언더스코어를 공백으로 변환
                .collect(Collectors.toList());
    }
}
