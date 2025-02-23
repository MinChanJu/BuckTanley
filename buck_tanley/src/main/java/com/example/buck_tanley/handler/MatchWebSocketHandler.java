package com.example.buck_tanley.handler;

// import java.io.IOException;
import java.util.concurrent.BlockingQueue;
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.LinkedBlockingQueue;

import org.springframework.stereotype.Component;
// import org.springframework.web.socket.CloseStatus;
import org.springframework.web.socket.TextMessage;
import org.springframework.web.socket.WebSocketSession;
import org.springframework.web.socket.handler.TextWebSocketHandler;

import com.example.buck_tanley.domain.dto.MatchDTO;
import com.example.buck_tanley.domain.dto.UserDTO;
// import com.example.buck_tanley.service.MatchService;
import com.example.buck_tanley.service.UserService;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.SerializationFeature;
import com.fasterxml.jackson.datatype.jsr310.JavaTimeModule;

@Component
public class MatchWebSocketHandler extends TextWebSocketHandler {

  // 매칭 대기열 (유저 ID 저장)
  private final BlockingQueue<UserDTO> waitingQueue = new LinkedBlockingQueue<>();
  private final ConcurrentHashMap<String, WebSocketSession> userSessions = new ConcurrentHashMap<>();
  private final ConcurrentHashMap<String, Boolean> acceptUser = new ConcurrentHashMap<>();
  private final ObjectMapper objectMapper = new ObjectMapper().registerModule(new JavaTimeModule())
      .disable(SerializationFeature.WRITE_DATES_AS_TIMESTAMPS);
  private UserService userService;

  public MatchWebSocketHandler(UserService userService) {
    this.userService = userService;
  }

  @SuppressWarnings("null")
  @Override
  public void afterConnectionEstablished(WebSocketSession session) {
    String userId = (String) session.getAttributes().get("userId");
    if (userId != null) {
      UserDTO user = userService.getUserDTO(userId);
      if (user != null) {
        System.out.println("🔌 매칭 사용자 등록: " + userId);
        userSessions.put(userId, session);
        waitingQueue.offer(user);
        matchUsers();
      } else {
        System.out.println("⚠️ 매칭 사용자 ID가 올바르지 않습니다.");
      }
    } else {
      System.out.println("⚠️ 매칭 사용자 ID가 전달되지 않았습니다.");
    }
  }

  public void matchUsers() {
    while (waitingQueue.size() >= 2) {
      UserDTO user1 = waitingQueue.poll();
      UserDTO user2 = waitingQueue.poll();

      System.out.println("🎯 매칭 성공: " + user1.getUserId() + " <-> " + user2.getUserId());

      sendMatch(new MatchDTO("매칭", user1, user2));
      sendMatch(new MatchDTO("매칭", user2, user1));

      acceptUser.put(user1.getUserId(), false);
      acceptUser.put(user2.getUserId(), false);
    }
  }

  // 매칭 성공 메시지 전송
  private void sendMatch(MatchDTO matchDTO) {
    try {
      String userId = matchDTO.getUser1().getUserId();
      String response = objectMapper.writeValueAsString(matchDTO);
      WebSocketSession session = userSessions.get(userId);
      session.sendMessage(new TextMessage(response));
      System.out.println("🎯 매칭 메세지 전달 -> " + userId);
    } catch (Exception e) {
      System.out.println("❌ 매칭 전송 실패: " + e.getMessage());
    }
  }

  @SuppressWarnings("null")
  @Override
  protected void handleTextMessage(WebSocketSession session, TextMessage textMessage) throws Exception {
    System.out.println("메세지 받음");
    String payload = textMessage.getPayload();

    try {
      MatchDTO matchDTO = objectMapper.readValue(payload, MatchDTO.class);
      UserDTO user1 = matchDTO.getUser1();
      UserDTO user2 = matchDTO.getUser2();

      String userId1 = user1.getUserId();
      String userId2 = user2.getUserId();

      System.out.println("📨 매칭 받은 메세지: " + matchDTO.getStatus() + " " + userId1 + " " + userId2);

      userSessions.put(user1.getUserId(), session);

      if (matchDTO.getStatus().equals("수락")) {
        if (acceptUser.containsKey(userId2)) {
          if (acceptUser.get(userId2)) {
            sendMatch(new MatchDTO("매칭 승인", user1, user2));
            sendMatch(new MatchDTO("매칭 승인", user2, user1));
          } else {
            acceptUser.put(userId1, true);
          }
        } else {
          sendMatch(new MatchDTO("매칭 취소", user1, user2));
        }
      } else if (matchDTO.getStatus().equals("거절")) {
        sendMatch(new MatchDTO("매칭 거절", user1, user2));
        sendMatch(new MatchDTO("매칭 거절", user2, user1));
      } else if (matchDTO.getStatus().equals("취소")) {
        sendMatch(new MatchDTO("매칭 취소", user1, user2));
      }
    } catch (Exception e) {
      System.out.println("❌ 매칭 메세지 처리 실패: " + e.getMessage());
      session.sendMessage(new TextMessage("⚠️ 매칭 잘못된 메세지 형식입니다."));
    }
  }

  @SuppressWarnings("null")
  @Override
  public void afterConnectionClosed(WebSocketSession session, org.springframework.web.socket.CloseStatus status) {
    String userId = (String) session.getAttributes().get("userId");
    waitingQueue.remove(new UserDTO(userId));
    userSessions.remove(userId);
    acceptUser.remove(userId);
    System.out.println("🔌 매칭 사용자 연결 해제: " + userId);
  }

  @SuppressWarnings("null")
  @Override
  public void handleTransportError(WebSocketSession session, Throwable exception) throws Exception {
    System.err.println("⚠️ 매칭 오류 발생: " + exception.getMessage());
  }
}
