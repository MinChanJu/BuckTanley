package com.example.buck_tanley.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.example.buck_tanley.domain.dto.ApiResponse;
import com.example.buck_tanley.domain.entity.Friend;
import com.example.buck_tanley.domain.entity.User;
import com.example.buck_tanley.service.FriendService;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;

import java.util.List;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;

@RestController
@RequestMapping("/api/friends")
public class FriendController {

    @Autowired
    private FriendService friendService;

    @GetMapping("/all")
    public ResponseEntity<ApiResponse<List<User>>> getAllFriendsByUserId(@RequestParam("userId") String userId) {
        List<User> friends = friendService.getAllFriendsByUserId(userId);
        ApiResponse<List<User>> response = new ApiResponse<>(200, true, "친구 리스트 조회 성공", friends);
        return ResponseEntity.status(HttpStatus.OK).body(response);
    }

    @PostMapping("/request")
    public ResponseEntity<ApiResponse<Friend>> requestFriend(@RequestBody Friend friend) {
        Friend requestFriend = friendService.createFriend(friend.getUserId1(), friend.getUserId2());
        ApiResponse<Friend> response = new ApiResponse<>(201, true, "친구 요청 전송 성공", requestFriend);
        return ResponseEntity.status(HttpStatus.CREATED).body(response);
    }

    @PostMapping("/accept")
    public ResponseEntity<ApiResponse<Void>> updateFriend(@RequestBody Friend friend) {
        friendService.updateFriend(friend);
        ApiResponse<Void> response = new ApiResponse<>(200, true, "친구 요청 수락 및 거절 성공", null);
        return ResponseEntity.status(HttpStatus.OK).body(response);
    }
    
    @PostMapping("/delete")
    public ResponseEntity<ApiResponse<Void>> deleteFriend(@RequestBody Friend friend) {
        friendService.deleteFriend(friend.getId());
        ApiResponse<Void> response = new ApiResponse<>(200, true, "친구 삭제 성공", null);
        return ResponseEntity.status(HttpStatus.OK).body(response);
    }
    
}
