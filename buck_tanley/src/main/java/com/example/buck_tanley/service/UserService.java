package com.example.buck_tanley.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.buck_tanley.domain.dto.LoginDTO;
import com.example.buck_tanley.domain.dto.UserDTO;
import com.example.buck_tanley.domain.entity.User;
import com.example.buck_tanley.exception.CustomException;
import com.example.buck_tanley.exception.ErrorCode;
import com.example.buck_tanley.repository.UserRepository;

import java.time.ZonedDateTime;
import java.util.*;

@Service
public class UserService {

    @Autowired
    private UserRepository userRepository;

    public UserService(UserRepository userRepository) {
        this.userRepository = userRepository;
    }

    public User getUserById(Long id) {
        if (id == null)
            throw new CustomException(ErrorCode.USER_NOT_FOUND);

        Optional<User> user = userRepository.findById(id);
        if (user.isEmpty())
            throw new CustomException(ErrorCode.USER_NOT_FOUND);

        return user.get();
    }

    public UserDTO getUserDTO(String userId) {
        if (userId == null) return null;

        Optional<User> findUser = userRepository.findByUserId(userId);
        if (findUser.isEmpty())
            return null;
        
        UserDTO user = new UserDTO(findUser.get());

        return user;
    }

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

        user.setStatus((short) 0); // 기존 상태

        user.setCreatedAt(ZonedDateTime.now());

        return userRepository.save(user);
    }

    public User updateUser(User user) {
        if (user.getId() == null)
            throw new CustomException(ErrorCode.USER_NOT_FOUND);

        Optional<User> findUser = userRepository.findById(user.getId());
        if (findUser.isEmpty())
            throw new CustomException(ErrorCode.USER_NOT_FOUND);

        return userRepository.save(user);
    }

    public void updateUserStatus(String userId, short status) {
        if (userId == null || status < 0 || status > 3)
            throw new CustomException(ErrorCode.USER_NOT_FOUND);
        
        int record = userRepository.updateUserStatus(userId, status);
        System.out.println("🔄 사용자 상태 변경: " + userId + " " + status + " " + record);
    }

    public void deleteUser(Long id) {
        if (id == null)
            throw new CustomException(ErrorCode.USER_NOT_FOUND);
        Optional<User> user = userRepository.findById(id);
        if (user.isEmpty())
            throw new CustomException(ErrorCode.USER_NOT_FOUND);

        userRepository.delete(user.get());
    }

    public User loginUser(LoginDTO loginDTO) {
        if (loginDTO.getUserId() == null || loginDTO.getUserPw() == null)
            throw new CustomException(ErrorCode.INVALID_CREDENTIALS);

        Optional<User> findUser = userRepository.findByUserIdAndUserPw(loginDTO.getUserId(), loginDTO.getUserPw());
        if (findUser.isEmpty())
            throw new CustomException(ErrorCode.INVALID_CREDENTIALS);
        
        userRepository.updateUserStatus(loginDTO.getUserId(), (short) 1);
        
        return findUser.get();
    }
}