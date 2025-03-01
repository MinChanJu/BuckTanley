package com.example.buck_tanley.service;

import java.time.ZonedDateTime;
import java.util.List;
import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.buck_tanley.domain.entity.Friend;
import com.example.buck_tanley.domain.entity.User;
import com.example.buck_tanley.exception.CustomException;
import com.example.buck_tanley.exception.ErrorCode;
import com.example.buck_tanley.repository.FriendRepository;

@Service
public class FriendService {

    @Autowired
    private FriendRepository friendRepository;

    public List<User> getAllFriendsByUserId(String userId) {
        return friendRepository.findAllByUserId(userId);
    }

    public Friend createFriend(String userId1, String userId2) {
        Optional<Friend> findFriend = friendRepository.findByUserId1AndUserId2(userId1, userId2);
        if (findFriend.isPresent()) { // 이미 친구인 경우
            throw new CustomException(ErrorCode.DUPLICATE_USER_ID);
        }

        Friend friend = new Friend(null, userId1, userId2, ZonedDateTime.now()); // 친구 요청 전송
        return friendRepository.save(friend);
    }

    public void updateFriend(Friend friend) {
        Optional<Friend> findFriend = friendRepository.findById(friend.getId());
        if (findFriend.isEmpty()) {
            throw new CustomException(ErrorCode.DUPLICATE_USER_ID);
        }
        friendRepository.save(friend);
    }

    public void deleteFriend(Long id) { // 친구 삭제
        friendRepository.deleteById(id);
    }
}
