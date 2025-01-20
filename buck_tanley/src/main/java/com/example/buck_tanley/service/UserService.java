package com.example.buck_tanley.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.buck_tanley.domain.entity.User;
import com.example.buck_tanley.exception.CustomException;
import com.example.buck_tanley.exception.ErrorCode;
import com.example.buck_tanley.repository.UserRepository;

@Service
public class UserService {

    @Autowired
    private UserRepository userRepository;

    public User creatUser(User user) {
        if (userRepository.existsByUserId(user.getUserId())) throw new CustomException(ErrorCode.DUPLICATE_USER_ID);
        return userRepository.save(user);
    }
}
