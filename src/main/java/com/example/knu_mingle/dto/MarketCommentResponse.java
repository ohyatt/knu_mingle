package com.example.knu_mingle.dto;

import com.example.knu_mingle.domain.Comment;
import com.example.knu_mingle.domain.Enum.Faculty;
import com.example.knu_mingle.domain.Enum.Gender;
import com.example.knu_mingle.domain.Enum.Nation;
import com.example.knu_mingle.domain.Market;
import com.example.knu_mingle.domain.User;
import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;

import java.time.LocalDateTime;

@Getter
@Setter
public class MarketCommentResponse {
    private Long comment_id;
    private String content;
    private boolean isPublic;
    private LocalDateTime createdAt;
    private LocalDateTime modifiedAt;
    private Long user_id;
    private String first_name;
    private String last_name;
    private Gender gender;
    private String email;
    private Nation nation;
    private Faculty faculty;

    public MarketCommentResponse(Comment comment) {
        this.comment_id = comment.getId();
        this.content = comment.getContent();
        this.isPublic = comment.isPublic();
        this.createdAt = comment.getCreatedAt();
        this.modifiedAt = comment.getModifiedAt();
        this.user_id = comment.getUser().getId();
        this.gender = comment.getUser().getGender();
        this.nation = comment.getUser().getNation();
        this.faculty = comment.getUser().getFaculty();

        if(comment.getContent().equals("deleted comment")){
            this.first_name = "deleted";
            this.last_name = "deleted";
            this.email = "deleted";
        }
        else{
            this.first_name = comment.getUser().getFirst_name();
            this.last_name = comment.getUser().getLast_name();
            this.email = comment.getUser().getEmail();
        }
    }
}
