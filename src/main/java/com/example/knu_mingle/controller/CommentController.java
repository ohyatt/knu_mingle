package com.example.knu_mingle.controller;

import com.example.knu_mingle.dto.CommentRequest;
import com.example.knu_mingle.service.CommentService;
import io.swagger.v3.oas.annotations.Operation;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpHeaders;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/comments")
public class CommentController {
    @Autowired
    private CommentService commentService;

    @Operation(summary = "댓글 작성")
    @PostMapping("/{market_id}")
    public ResponseEntity<Object> write(@RequestHeader(HttpHeaders.AUTHORIZATION) String accessToken, @PathVariable Long market_id, @RequestBody CommentRequest commentRequest) {
        return ResponseEntity.ok(commentService.write(accessToken, market_id, commentRequest));
    }

    @Operation(summary = "댓글 수정")
    @PutMapping("/{market_id}/{comment_id}")
    public ResponseEntity<Object> update(@RequestHeader(HttpHeaders.AUTHORIZATION) String accessToken, @PathVariable Long market_id, @PathVariable Long comment_id, @RequestBody CommentRequest commentRequest) {
        return ResponseEntity.ok(commentService.update(accessToken, market_id, comment_id, commentRequest));
    }

    @Operation(summary = "댓글 삭제")
    @PutMapping("/delete/{market_id}/{comment_id}")
    public ResponseEntity<Object> delete(@RequestHeader(HttpHeaders.AUTHORIZATION) String accessToken, @PathVariable Long market_id, @PathVariable Long comment_id) {
        return ResponseEntity.ok(commentService.delete(accessToken, market_id, comment_id));
    }

}
