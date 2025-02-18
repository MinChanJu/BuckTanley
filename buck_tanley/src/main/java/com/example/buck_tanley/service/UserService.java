package com.example.buck_tanley.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.example.buck_tanley.domain.entity.User;
import com.example.buck_tanley.exception.CustomException;
import com.example.buck_tanley.exception.ErrorCode;
import com.example.buck_tanley.repository.UserRepository;

import java.util.*;

@Service
public class UserService {

    @Autowired
    private UserRepository userRepository;

    public UserService(UserRepository userRepository) {
        this.userRepository = userRepository;
    }

    @Transactional(readOnly = true)
    public User getUserById(Long id) {
        if (id == null)
            throw new CustomException(ErrorCode.USER_NOT_FOUND);

        Optional<User> user = userRepository.findById(id);
        if (user.isEmpty())
            throw new CustomException(ErrorCode.USER_NOT_FOUND);

        return user.get();
    }

    @Transactional
    public User createUser(User user) {
        if (userRepository.existsByUserId(user.getUserId()))
            throw new CustomException(ErrorCode.DUPLICATE_USER_ID);

        String password = user.getUserPw();
        if (!password.matches(".*[a-zA-Z].*"))
            throw new CustomException(ErrorCode.INVALID_PASSWORD_ALP); // 영문자 포함 확인

        if (!password.matches(".*\\d.*"))
            throw new CustomException(ErrorCode.INVALID_PASSWORD_NUM); // 숫자 포함 확인

        if (!password.matches("[a-zA-Z0-9]+"))
            throw new CustomException(ErrorCode.INVALID_PASSWORD_SPE); // 특수문자 포함 확인

        if (password.length() < 10)
            throw new CustomException(ErrorCode.INVALID_PASSWORD_LEN); // 길이 10자 이상 확인

        return userRepository.save(user);
    }

    @Transactional
    public User updateUser(User user) {
        if (user.getId() == null)
            throw new CustomException(ErrorCode.USER_NOT_FOUND);

        Optional<User> findUser = userRepository.findById(user.getId());
        if (findUser.isEmpty())
            throw new CustomException(ErrorCode.USER_NOT_FOUND);

        return userRepository.save(user);
    }

    @Transactional
    public void deleteUser(Long id) {
        if (id == null)
            throw new CustomException(ErrorCode.USER_NOT_FOUND);
        Optional<User> user = userRepository.findById(id);
        if (user.isEmpty())
            throw new CustomException(ErrorCode.USER_NOT_FOUND);

        userRepository.delete(user.get());
    }

    @Transactional
    public Optional<User> authenticalUser(String userId, String userPw) {
        if (userId == null || userPw == null)
            throw new CustomException(ErrorCode.INVALID_CREDENTIALS);

        Optional<User> user = userRepository.findByUserId(userId);
        if (user.isEmpty())
            throw new CustomException(ErrorCode.USER_NOT_FOUND);

        if (!user.get().getUserPw().equals(userPw)) // 실제 시스템에서는 비밀번호 암호화를 사용해야 합니다.
            throw new CustomException(ErrorCode.INVALID_CREDENTIALS);

        return user;
    }

}