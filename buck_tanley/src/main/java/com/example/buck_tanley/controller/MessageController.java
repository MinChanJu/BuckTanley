package com.example.buck_tanley.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.example.buck_tanley.domain.dto.ApiResponse;
import com.example.buck_tanley.domain.entity.Message;
import com.example.buck_tanley.service.MessageService;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;


@RestController
@RequestMapping("/api/messages")
public class MessageController {
  
  @Autowired private MessageService messageService;

  @GetMapping("/{userId}")
  public ResponseEntity<ApiResponse<List<Message>>> getMethodName(@PathVariable("userId") String userId) {
    List<Message> messages = messageService.getAllMessagesByUserId(userId);
    ApiResponse<List<Message>> response = new ApiResponse<>(200, true, "조회 성공!", messages);
    return ResponseEntity.status(HttpStatus.OK).body(response);
  }
  
}