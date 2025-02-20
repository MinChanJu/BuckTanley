package com.example.buck_tanley.service;

import java.util.List;
import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;

import com.example.buck_tanley.domain.entity.Friend;
import com.example.buck_tanley.domain.entity.User;
import com.example.buck_tanley.exception.CustomException;
import com.example.buck_tanley.exception.ErrorCode;
import com.example.buck_tanley.repository.FriendRepository;

public class FriendService {

    @Autowired
    private FriendRepository friendRepository;

    public List<User> getAllFriendsByUserId(String userId) {
        return friendRepository.findFriends(userId);
    }

    public Friend createFriend(String userId1, String userId2) {
        Optional<Friend> findFriend = friendRepository.findByUserId1AndUserId2(userId1, userId2);
        if (findFriend.isPresent()) { // 양측 친구 요청
            Friend friend = findFriend.get();
            friend.setStatus((short) 0); // 친구 요청 수락
            return friendRepository.save(friend);
        }

        Friend friend = new Friend(null, userId1, userId2, (short) 1, null); // 친구 요청 전송
        return friendRepository.save(friend);
    }

    public void updateFriend(Friend friend) {
        Optional<Friend> findFriend = friendRepository.findById(friend.getId());
        if (findFriend.isEmpty()) {
            throw new CustomException(ErrorCode.DUPLICATE_USER_ID);
        }

        if (friend.getStatus() > 0) { // 요청 수락
            friendRepository.save(friend);
        } else { // 요청 거절
            friendRepository.delete(friend);
        }
    }

    public void deleteFriend(Long id) { // 친구 삭제
        friendRepository.deleteById(id);
    }
}
