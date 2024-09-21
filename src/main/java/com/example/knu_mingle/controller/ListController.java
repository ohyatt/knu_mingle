package com.example.knu_mingle.controller;

import com.example.knu_mingle.service.ListService;
import io.swagger.v3.oas.annotations.Operation;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
@RequestMapping("/lists")
public class ListController {
    @Autowired
    private ListService listService;

    @Operation(summary = "국가 목록 반환")
    @GetMapping("/nations")
    public ResponseEntity<List<String>> getNationList() {
        return ResponseEntity.ok(listService.getNations());
    }

    @Operation(summary = "단대 목록 반환")
    @GetMapping("/faculties")
    public ResponseEntity<List<String>> getFacultyList() {
        return ResponseEntity.ok(listService.getFaculties());
    }
}
