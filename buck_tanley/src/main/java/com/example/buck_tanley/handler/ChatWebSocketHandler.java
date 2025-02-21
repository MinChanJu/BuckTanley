package com.example.buck_tanley.handler;

import org.springframework.web.socket.WebSocketSession;
import org.springframework.web.socket.handler.TextWebSocketHandler;
import org.springframework.stereotype.Component;
import org.springframework.web.socket.CloseStatus;
import org.springframework.web.socket.TextMessage;

import com.example.buck_tanley.domain.entity.Message;
import com.example.buck_tanley.service.MessageService;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.SerializationFeature;
import com.fasterxml.jackson.datatype.jsr310.JavaTimeModule;

import java.io.IOException;
import java.util.concurrent.ConcurrentHashMap;

@Component
public class ChatWebSocketHandler extends TextWebSocketHandler {

  // 사용자별 웹소켓 세션 관리 (userId -> (type -> session))
  private final ConcurrentHashMap<String, ConcurrentHashMap<String, WebSocketSession>> userSessions = new ConcurrentHashMap<>();
  // 매칭 대기열 (유저 ID 저장)
  private final ObjectMapper objectMapper = new ObjectMapper().registerModule(new JavaTimeModule())
      .disable(SerializationFeature.WRITE_DATES_AS_TIMESTAMPS);
  private MessageService messageService;

  public ChatWebSocketHandler(MessageService messageService) {
    this.messageService = messageService;
  }

  @SuppressWarnings("null")
  @Override
  public void afterConnectionEstablished(WebSocketSession session) {
    String userId = (String) session.getAttributes().get("userId");
    String type = (String) session.getAttributes().get("type");
    if (userId != null && type != null) {
      userSessions.computeIfAbsent(userId, k -> new ConcurrentHashMap<>()).put(type, session);
      System.out.println("🔌 사용자 연결 " + type + " : " + userId);
    } else {
      System.out.println("⚠️ userId 또는 type이 전달되지 않았습니다.");
    }
  }

  @SuppressWarnings("null")
  @Override
  protected void handleTextMessage(WebSocketSession session, TextMessage textMessage) throws Exception {
    String type = (String) session.getAttributes().get("type");
    String payload = textMessage.getPayload();
    System.out.println("📨 받은 메세지 " + type + " : " + payload);

    try {
      Message message = objectMapper.readValue(payload, Message.class);

      switch (type) {
        case "chat":
          messageService.createMessage(message);
          sendMessage(message, 0, type);
          sendMessage(message, 1, type);
          break;
        case "random":
          if (message.getId() == null) { // 메세지 전송
            sendMessage(message, 0, type);
            sendMessage(message, 1, type);
          } else { // 연결 종료
            forceCloseConnection(message.getSender(), type);
            forceCloseConnection(message.getReceiver(), type);
          }
          break;
        default:
          System.out.println("type이 잘못 됨: " + type);
          break;
      }
    } catch (Exception e) {
      System.out.println("❌ 메세지 처리 실패 " + type + " : " + e.getMessage());
      session.sendMessage(new TextMessage("⚠️ 잘못된 메세지 형식입니다."));
    }
  }

  // 메세지 전송
  private void sendMessage(Message message, int SR, String type) throws Exception {
    String response = objectMapper.writeValueAsString(message);
    String userId = SR == 0 ? message.getSender() : message.getReceiver();

    ConcurrentHashMap<String, WebSocketSession> userMap = userSessions.get(userId);
    if (userMap != null) {
      WebSocketSession userSession = userMap.get(type);
      if (userSession != null && userSession.isOpen()) {
        if (SR == 0 || !message.getSender().equals(message.getReceiver())) {
          userSession.sendMessage(new TextMessage(response));
          System.out.println("📤 메세지 전송 완료 " + type + " : " + userId);
          SR = 10;
        } else if (type.equals("chat")) {
          System.out.println("📤 메세지 전송 완료 " + type + " : " + userId + "(본인)");
          SR = 10;
        }
      }
    }

    if (SR != 10) {
      System.out.println("⚠️ 수신자 세션이 잘못되었습니다 " + type + " : " + userId);
      if (type.equals("random")) {
        forceCloseConnection(message.getSender(), type);
        forceCloseConnection(message.getReceiver(), type);
      }
    }
  }

  public void forceCloseConnection(String userId, String type) {
    try {
      ConcurrentHashMap<String, WebSocketSession> userMap = userSessions.get(userId);
      if (userMap != null) {
        WebSocketSession userSession = userMap.get(type);
        if (userSession != null) {
          userMap.remove(type);
          if (userMap.isEmpty()) {
            userSessions.remove(userId);
          }
          if (userSession.isOpen()) {
            userSession.close(CloseStatus.NORMAL);
          }
        }
      }

      System.out.println("🔌 사용자 연결 강제 종료 " + type + " : " + userId);
    } catch (IOException e) {
      e.printStackTrace();
    }
  }

  @SuppressWarnings("null")
  @Override
  public void afterConnectionClosed(WebSocketSession session, org.springframework.web.socket.CloseStatus status) {
    String userId = (String) session.getAttributes().get("userId");
    String type = (String) session.getAttributes().get("type");
    ConcurrentHashMap<String, WebSocketSession> userMap = userSessions.get(userId);
    if (userMap != null) {
      userMap.remove(type);
      if (userMap.isEmpty()) {
        userSessions.remove(userId);
      }
    }
    System.out.println("🔌 사용자 연결 해제 " + type + " : " + userId);
  }

  @SuppressWarnings("null")
  @Override
  public void handleTransportError(WebSocketSession session, Throwable exception) throws Exception {
    String userId = (String) session.getAttributes().get("userId");
    String type = (String) session.getAttributes().get("type");
    System.err.println("⚠️ 오류 발생 " + type + " : " + userId + " ->" + exception.getMessage());
  }

}