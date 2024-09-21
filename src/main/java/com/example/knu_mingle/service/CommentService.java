package com.example.knu_mingle.service;

import com.example.knu_mingle.domain.Comment;
import com.example.knu_mingle.domain.Market;
import com.example.knu_mingle.domain.User;
import com.example.knu_mingle.dto.CommentRequest;
import com.example.knu_mingle.repository.CommentRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.web.server.ResponseStatusException;

@Service
public class CommentService {
    @Autowired
    UserService userService;
    @Autowired
    MarketService marketService;
    @Autowired
    CommentRepository commentRepository;

    public Object write(String accessToken, Long marketId, CommentRequest commentRequest) {
        User user = userService.getUserByToken(accessToken);
        Market market = marketService.getMarketById(marketId);
        Comment comment = commentRequest.to(user, market);
        commentRepository.save(comment);
        return "Success";
    }

    public Object update(String accessToken, Long marketId, Long commentId, CommentRequest commentRequest) {
        User user = userService.getUserByToken(accessToken);
        Market market = marketService.getMarketById(marketId);
        Comment comment = commentRepository.findById(commentId).orElse(null);

        if (!comment.getMarket().getId().equals(market.getId())) {
            throw new ResponseStatusException(HttpStatus.FORBIDDEN, "market or comment ID를 확인해주세요");
        }

        // 댓글 작성자 확인
        if (!comment.getUser().getId().equals(user.getId())) {
            throw new ResponseStatusException(HttpStatus.FORBIDDEN, "You do not have permission to update this comment.");
        }

        commentRepository.save(commentRequest.update(comment));
        return "Success";
    }

    public Object delete(String accessToken, Long marketId, Long commentId) {
        User user = userService.getUserByToken(accessToken);
        Market market = marketService.getMarketById(marketId);
        Comment comment = commentRepository.findById(commentId).orElse(null);

        if (!comment.getMarket().getId().equals(market.getId())) {
            throw new ResponseStatusException(HttpStatus.FORBIDDEN, "market or comment ID를 확인해주세요");
        }

        // 댓글 작성자 확인
        if (!comment.getUser().getId().equals(user.getId())) {
            throw new ResponseStatusException(HttpStatus.FORBIDDEN, "You do not have permission to update this comment.");
        }
        comment.setContent("삭제된 댓글입니다.");
        // 더미 유저 넣어야함 그 로직 까먹지 말기 디비에 넣어야댐
        commentRepository.save(comment);
        return "Success";
    }
}
