package com.example.buck_tanley.service;

import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

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

    private UserRepository userRepository;
    private ImageService imageService;
    private FcmTokenService fcmService;

    public UserService(UserRepository userRepository, ImageService imageService, FcmTokenService fcmService) {
        this.userRepository = userRepository;
        this.imageService = imageService;
        this.fcmService = fcmService;
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
        if (userId == null)
            return null;

        Optional<User> findUser = userRepository.findByUserId(userId);
        if (findUser.isEmpty())
            return null;

        UserDTO user = new UserDTO(findUser.get());

        return user;
    }

    public User createUser(User user, MultipartFile imageFile) {
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
        if (imageFile != null) {
            String imageUrl = imageService.uploadImage(imageFile, user.getUserId());
            user.setImage(imageUrl);
        }

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

        User user = findUser.get();
        user.setStatus((short) 1);
        userRepository.save(user);

        fcmService.createFcmToken(loginDTO.getUserId(), loginDTO.getPlatform(), loginDTO.getFcmToken());
        
        return user;
    }
}