package com.example.knu_mingle.repository;

import com.example.knu_mingle.domain.Location;
import org.springframework.data.jpa.repository.JpaRepository;

public interface LocationRepository extends JpaRepository<Location, Long> {
}
