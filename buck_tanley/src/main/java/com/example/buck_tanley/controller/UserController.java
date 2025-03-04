package com.example.buck_tanley.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestPart;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;

import com.example.buck_tanley.domain.dto.ApiResponse;
import com.example.buck_tanley.domain.dto.LoginDTO;
import com.example.buck_tanley.domain.entity.User;
import com.example.buck_tanley.service.UserService;
import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.SerializationFeature;
import com.fasterxml.jackson.datatype.jsr310.JavaTimeModule;

import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;

@RestController
@RequestMapping("/api/users")
public class UserController {

    @Autowired
    private UserService userService;

    @PostMapping("/login")
    public ResponseEntity<ApiResponse<User>> loginUser(@RequestBody LoginDTO loginDTO) {
        User user = userService.loginUser(loginDTO);
        ApiResponse<User> response = new ApiResponse<>(200, true, "로그인 성공", user);
        return ResponseEntity.status(HttpStatus.OK).body(response);
    }

    @PostMapping(value = "/register", consumes = { "multipart/form-data" })
    public ResponseEntity<ApiResponse<User>> registerUser(@RequestPart("user") String userJson,
            @RequestPart(value = "image", required = false) MultipartFile imageFile) {
        ObjectMapper objectMapper = new ObjectMapper().registerModule(new JavaTimeModule())
                .disable(SerializationFeature.WRITE_DATES_AS_TIMESTAMPS);
        User userDetail;
        try {
            System.out.println("🚀 userJson: " + userJson);
            userDetail = objectMapper.readValue(userJson, User.class);
        } catch (JsonProcessingException e) {
            return ResponseEntity.badRequest().body(new ApiResponse<>(400, false, "잘못된 JSON 형식입니다.", null));
        }
        User user = userService.createUser(userDetail, imageFile);
        ApiResponse<User> response = new ApiResponse<>(201, true, "회원가입 성공", user);
        return ResponseEntity.status(HttpStatus.CREATED).body(response);
    }

    @PostMapping("/update")
    public ResponseEntity<ApiResponse<User>> updateUser(@RequestBody User userDetail) {
        User user = userService.updateUser(userDetail);
        ApiResponse<User> response = new ApiResponse<>(200, true, "회원정보 수정 성공", user);
        return ResponseEntity.status(HttpStatus.OK).body(response);
    }
}
