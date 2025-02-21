package com.example.buck_tanley.handler;

import java.io.IOException;
import java.util.concurrent.BlockingQueue;
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.LinkedBlockingQueue;

import org.springframework.stereotype.Component;
import org.springframework.web.socket.CloseStatus;
import org.springframework.web.socket.TextMessage;
import org.springframework.web.socket.WebSocketSession;
import org.springframework.web.socket.handler.TextWebSocketHandler;

import com.example.buck_tanley.domain.dto.MatchDTO;
import com.example.buck_tanley.service.MatchService;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.SerializationFeature;
import com.fasterxml.jackson.datatype.jsr310.JavaTimeModule;

@Component
public class MatchWebSocketHandler extends TextWebSocketHandler {

  // 매칭 대기열 (유저 ID 저장)
  private final BlockingQueue<String> waitingQueue = new LinkedBlockingQueue<>();
  private final ConcurrentHashMap<String, WebSocketSession> userSessions = new ConcurrentHashMap<>();
  private final ConcurrentHashMap<String, Boolean> acceptUser = new ConcurrentHashMap<>();
  private final ObjectMapper objectMapper = new ObjectMapper().registerModule(new JavaTimeModule())
      .disable(SerializationFeature.WRITE_DATES_AS_TIMESTAMPS);
  // private MatchService matchService;

  public MatchWebSocketHandler(MatchService matchService) {
    // this.matchService = matchService;
  }

  @SuppressWarnings("null")
  @Override
  public void afterConnectionEstablished(WebSocketSession session) {
    String userId = (String) session.getAttributes().get("userId");
    if (userId != null) {
      userSessions.put(userId, session);
      waitingQueue.offer(userId);
      matchUsers();
      System.out.println("🔌 매칭 사용자 등록: " + userId);
    } else {
      System.out.println("⚠️ 매칭 사용자 ID가 전달되지 않았습니다.");
    }
  }

  public void matchUsers() {
    while (waitingQueue.size() >= 2) {
      String userId1 = waitingQueue.poll();
      String userId2 = waitingQueue.poll();
      WebSocketSession session1 = userSessions.get(userId1);
      WebSocketSession session2 = userSessions.get(userId2);

      // 매칭 성공 메시지 전송
      sendMatchSuccess(session1, new MatchDTO(false, userId1, userId2));
      sendMatchSuccess(session2, new MatchDTO(false, userId2, userId1));

      acceptUser.put(userId1, false);
      acceptUser.put(userId2, false);

      System.out.println("🎯 매칭 성공: " + userId1 + " <-> " + userId2);
    }
  }

  // 매칭 성공 메시지 전송
  private void sendMatchSuccess(WebSocketSession session, MatchDTO matchDTO) {
    try {
      String response = objectMapper.writeValueAsString(matchDTO);
      session.sendMessage(new TextMessage(response));
      System.out.println("🎯 매칭 성공 전달 -> " + matchDTO.getUserId1() + " : " + response);
    } catch (Exception e) {
      System.out.println("❌ 매칭 전송 실패: " + e.getMessage());
    }
  }

  @SuppressWarnings("null")
  @Override
  protected void handleTextMessage(WebSocketSession session, TextMessage textMessage) throws Exception {
    String payload = textMessage.getPayload();
    System.out.println("📨 매칭 받은 메세지: " + payload);

    try {
      MatchDTO matchDTO = objectMapper.readValue(payload, MatchDTO.class);
      String userId1 = matchDTO.getUserId1();
      String userId2 = matchDTO.getUserId2();
      WebSocketSession session1 = userSessions.get(userId1);
      WebSocketSession session2 = userSessions.get(userId2);
      
      if (matchDTO.isStatus()) {
        if (acceptUser.get(userId2)) {
          sendMatchSuccess(session1, new MatchDTO(true, userId1, userId2));
          sendMatchSuccess(session2, new MatchDTO(true, userId2, userId1));

          acceptUser.remove(userId1);
          acceptUser.remove(userId2);

          forceCloseConnection(session1);
          forceCloseConnection(session2);
        } else {
          acceptUser.put(userId1, true);
        }
      } else {
        sendMatchSuccess(session1, new MatchDTO(false, userId1, userId2));
        sendMatchSuccess(session2, new MatchDTO(false, userId2, userId1));

        acceptUser.remove(userId1);
        acceptUser.remove(userId2);

        forceCloseConnection(session1);
        forceCloseConnection(session2);
      }
    } catch (Exception e) {
      System.out.println("❌ 매칭 메세지 처리 실패: " + e.getMessage());
      session.sendMessage(new TextMessage("⚠️ 매칭 잘못된 메세지 형식입니다."));
    }
  }

  public void forceCloseConnection(WebSocketSession session) {
    try {
      String userId = (String) session.getAttributes().get("userId");
      session.close(CloseStatus.NORMAL);
      userSessions.remove(userId);
      System.out.println("🔌 매칭 사용자 연결 강제 종료: " + userId);
    } catch (IOException e) {
      e.printStackTrace();
    }
  }

  @SuppressWarnings("null")
  @Override
  public void afterConnectionClosed(WebSocketSession session, org.springframework.web.socket.CloseStatus status) {
    String userId = (String) session.getAttributes().get("userId");
    waitingQueue.remove(userId);
    userSessions.remove(userId);
    System.out.println("🔌 매칭 사용자 연결 해제: " + userId);
  }

  @SuppressWarnings("null")
  @Override
  public void handleTransportError(WebSocketSession session, Throwable exception) throws Exception {
    System.err.println("⚠️ 매칭 오류 발생: " + exception.getMessage());
  }
}
