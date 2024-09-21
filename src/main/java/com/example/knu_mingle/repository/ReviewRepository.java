package com.example.knu_mingle.repository;

import com.example.knu_mingle.domain.Review;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface ReviewRepository extends JpaRepository<Review,Long> {

    //전체 리뷰
    List<Review> findAll();

    //키워드별 리뷰
    List<Review> findByKeyword(String keyword);

}