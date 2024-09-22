package com.example.knu_mingle.repository;

import com.example.knu_mingle.domain.Comment;
import com.example.knu_mingle.domain.Market;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface CommentRepository extends JpaRepository<Comment, Long> {
    List<Comment> getByMarket(Market market);
}
