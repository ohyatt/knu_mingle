package com.example.knu_mingle.dto;

import com.example.knu_mingle.domain.Comment;
import com.example.knu_mingle.domain.Market;
import com.example.knu_mingle.domain.User;

public class CommentRequest {
    private String content;
    private boolean isPublic;

    public Comment to(User user, Market market) {
        Comment comment = new Comment();
        comment.setContent(content);
        comment.setPublic(isPublic);
        comment.setUser(user);
        comment.setMarket(market);
        return comment;
    }

    public Comment update(Comment comment) {
        comment.setContent(content);
        comment.setPublic(isPublic);
        return comment;
    }
}
