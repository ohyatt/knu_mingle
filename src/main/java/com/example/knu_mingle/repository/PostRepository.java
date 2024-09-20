package com.example.knu_mingle.repository;

import com.example.knu_mingle.domain.Market;
import org.springframework.data.jpa.repository.JpaRepository;

public interface PostRepository extends JpaRepository<Market, Long> {
}
