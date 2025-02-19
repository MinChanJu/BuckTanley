package com.example.buck_tanley.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;

import com.example.buck_tanley.domain.entity.Friend;
import com.example.buck_tanley.domain.entity.User;
import com.example.buck_tanley.repository.FriendRepository;

public class FriendService {
    
    @Autowired
    private FriendRepository friendRepository;
    @Autowired
    private UserService userService;

    public List<User> getAllFriendsByUserId(String userId) {
        List<Friend> friends = friendRepository.findAllByUserId(userId);
        List<User> friendUsers;
        while (friends.isEmpty()) {
            
        }
    }

    public Friend createFriend(String userId1, String userId2){
        
    }

    public Friend updateFriend(Friend friend){

    }

    public void deleteFriend(Long id){
        friendRepository.deleteById(id);
    }
}
