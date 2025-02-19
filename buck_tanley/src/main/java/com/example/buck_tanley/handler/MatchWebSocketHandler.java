package com.example.buck_tanley.handler;

import java.util.concurrent.BlockingQueue;
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.LinkedBlockingQueue;

import org.springframework.stereotype.Component;
import org.springframework.web.socket.TextMessage;
import org.springframework.web.socket.WebSocketSession;
import org.springframework.web.socket.handler.TextWebSocketHandler;

import com.example.buck_tanley.service.MatchService;

@Component
public class MatchWebSocketHandler extends TextWebSocketHandler {

  // 매칭 대기열 (유저 ID 저장)
  private final BlockingQueue<String> waitingQueue = new LinkedBlockingQueue<>();
  private final ConcurrentHashMap<String, WebSocketSession> userSessions = new ConcurrentHashMap<>();
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
      System.out.println("🔌 사용자 등록: " + userId);
    } else {
      System.out.println("⚠️ 사용자 ID가 전달되지 않았습니다.");
    }
  }

  public void matchUsers() {
    while (waitingQueue.size() >= 2) {
      String user1 = waitingQueue.poll();
      String user2 = waitingQueue.poll();
      WebSocketSession session1 = userSessions.get(user1);
      WebSocketSession session2 = userSessions.get(user2);

      // 매칭 성공 메시지 전송
      sendMatchSuccess(session1, user1, user2);
      sendMatchSuccess(session2, user2, user1);

      System.out.println("🎯 매칭 성공: " + user1 + " <-> " + user2);
    }
  }

  // 매칭 성공 메시지 전송
  private void sendMatchSuccess(WebSocketSession session, String self, String partner) {
    try {
      String response = String.format("{\"status\":\"matched\", \"partner\":\"%s\"}", partner);
      session.sendMessage(new TextMessage(response));
      matchUsers();
    } catch (Exception e) {
      System.out.println("❌ 메시지 전송 실패: " + e.getMessage());
    }
  }

  @SuppressWarnings("null")
  @Override
  public void afterConnectionClosed(WebSocketSession session, org.springframework.web.socket.CloseStatus status) {
    String userId = (String) session.getAttributes().get("userId");
    waitingQueue.remove(userId);
    userSessions.remove(userId);
    System.out.println("🔌 사용자 연결 해제: " + userId);
  }

  @SuppressWarnings("null")
  @Override
  public void handleTransportError(WebSocketSession session, Throwable exception) throws Exception {
    System.err.println("⚠️ 오류 발생: " + exception.getMessage());
  }
}
