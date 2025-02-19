package com.example.buck_tanley.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.example.buck_tanley.domain.dto.ApiResponse;
import com.example.buck_tanley.domain.dto.LoginDTO;
import com.example.buck_tanley.domain.entity.User;
import com.example.buck_tanley.exception.CustomException;
import com.example.buck_tanley.exception.ErrorCode;
import com.example.buck_tanley.service.UserService;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;

import java.util.Optional;

@RestController
@RequestMapping("/api/users")
public class UserController {
    
    @Autowired private UserService userService;    

    @PostMapping("/signup")
    public ResponseEntity<ApiResponse<User>> signup(@RequestBody User userDetail) {
        User user = userService.createUser(userDetail);
        ApiResponse<User> response = new ApiResponse<>(201, true, "회원가입 성공", user);
        return ResponseEntity.status(HttpStatus.CREATED).body(response);
    }

    @PostMapping("/login")
    public ResponseEntity<ApiResponse<User>> loginUser(@RequestBody LoginDTO loginDTO) {
        Optional<User> userOptional = userService.authenticalUser(loginDTO.getUserId(), loginDTO.getUserPw());
        if (userOptional.isEmpty()){
            throw new CustomException(ErrorCode.INVALID_CREDENTIALS);
        }
        ApiResponse<User> response = new ApiResponse<>(200, true, "로그인 성공", userOptional.get());
        return ResponseEntity.status(HttpStatus.OK).body(response);
    }
    
}
