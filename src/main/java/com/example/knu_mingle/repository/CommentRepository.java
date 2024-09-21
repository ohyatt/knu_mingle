package com.example.knu_mingle.repository;

import com.example.knu_mingle.domain.Comment;
import org.springframework.data.jpa.repository.JpaRepository;

public interface CommentRepository extends JpaRepository<Comment, Long> {
}
