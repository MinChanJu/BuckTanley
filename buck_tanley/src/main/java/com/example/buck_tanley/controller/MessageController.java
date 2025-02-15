package com.example.buck_tanley.controller;

import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api")
public class MessageController {

  @GetMapping("/hello")
  public String hello() {
    return "WebSocket 서버가 실행 중입니다!";
  }
  
}
