package com.example.knu_mingle.repository;

import com.example.knu_mingle.domain.Enum.Feeling;
import com.example.knu_mingle.domain.Rating;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface RateRepository extends JpaRepository<Rating, Long> {
}
