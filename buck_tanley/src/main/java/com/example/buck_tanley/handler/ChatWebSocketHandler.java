package com.example.buck_tanley.handler;

import org.springframework.web.socket.WebSocketSession;
import org.springframework.web.socket.handler.TextWebSocketHandler;
import org.springframework.stereotype.Component;
import org.springframework.web.socket.TextMessage;

import com.example.buck_tanley.domain.entity.Message;
import com.example.buck_tanley.service.MessageService;
import com.fasterxml.jackson.databind.ObjectMapper;

import java.time.ZonedDateTime;
import java.time.format.DateTimeFormatter;
import java.util.*;
import java.util.concurrent.ConcurrentHashMap;

@Component
public class ChatWebSocketHandler extends TextWebSocketHandler {

    // 사용자별 채팅방 관리 (userId -> (roomId -> session))
    private final Map<String, Map<String, WebSocketSession>> userChatRooms = new ConcurrentHashMap<>();
    private final ObjectMapper objectMapper = new ObjectMapper();
    private MessageService messageService;

    public ChatWebSocketHandler(MessageService messageService) {
        this.messageService = messageService;
    }

    @SuppressWarnings("null")
    @Override
    public void afterConnectionEstablished(WebSocketSession session) {
        String userId = (String) session.getAttributes().get("userId");
        if (userId != null) {
            userChatRooms.putIfAbsent(userId, new ConcurrentHashMap<>());
            userChatRooms.get(userId).put("default", session);
            System.out.println("🔌 사용자 연결: " + userId);
        } else {
            System.out.println("⚠️ 사용자 ID가 전달되지 않았습니다.");
        }
    }

    @SuppressWarnings({ "null", "unchecked" })
    @Override
    protected void handleTextMessage(WebSocketSession session, TextMessage textMessage) throws Exception {
        String payload = textMessage.getPayload();
        System.out.println("📨 받은 메시지: " + payload);

        try {
            Map<String, String> data = objectMapper.readValue(payload, Map.class);
            String sender = data.get("sender");
            String receiver = data.get("receiver");
            String content = data.get("content");
            String roomId = generateRoomId(sender, receiver);

            // 수신자에게 메시지 전송
            sendPrivateMessage(sender, receiver, roomId, content, session);
        } catch (Exception e) {
            System.out.println("❌ 메시지 처리 실패: " + e.getMessage());
            session.sendMessage(new TextMessage("⚠️ 잘못된 메시지 형식입니다."));
        }
    }

    // 1:1 메시지 전송
    private void sendPrivateMessage(String sender, String receiver, String roomId, String content,
            WebSocketSession session) throws Exception {
        // sender의 세션 저장
        userChatRooms.computeIfAbsent(sender, k -> new ConcurrentHashMap<>()).putIfAbsent(roomId,
                userChatRooms.get(sender).get("default"));

        userChatRooms.computeIfAbsent(receiver, k -> new ConcurrentHashMap<>());

        Message message = new Message(null, sender, receiver, content, ZonedDateTime.now());
        messageService.createMessage(message);
        String response = new ObjectMapper().writeValueAsString(Map.of(
                        "id", message.getId(),
                        "sender", message.getSender(),
                        "receiver", message.getReceiver(),
                        "content", message.getContent(),
                        "createdAt", message.getCreatedAt().format(DateTimeFormatter.ISO_OFFSET_DATE_TIME)));
        session.sendMessage(new TextMessage(response));

        // receiver 세션 가져오기
        Map<String, WebSocketSession> receiverSessions = userChatRooms.get(receiver);
        if (receiverSessions != null) {
            WebSocketSession receiverSession = receiverSessions.get("default");
            if (receiverSession != null && receiverSession.isOpen()) {
                receiverSession.sendMessage(new TextMessage(response));
                System.out.println("📤 메시지 전송 완료 → " + receiver + " (웹소켓으로 전송)");
            } else {
                System.out.println("⚠️ 수신자를 찾을 수 없음: " + receiver + " (DB로 조회 가능)");
            }
        } else {
            System.out.println("⚠️ 수신자 세션이 없습니다: " + receiver + " (DB로 조회 가능)");
        }
    }

    // 채팅방 ID 생성 (사전순으로 정렬하여 고유 ID 생성)
    private String generateRoomId(String user1, String user2) {
        List<String> users = Arrays.asList(user1, user2);
        users.sort(String::compareTo);
        return users.get(0) + "_" + users.get(1);
    }

    @SuppressWarnings("null")
    @Override
    public void afterConnectionClosed(WebSocketSession session, org.springframework.web.socket.CloseStatus status) {
        String userId = (String) session.getAttributes().get("userId");
        userChatRooms.remove(userId);
        System.out.println("🔌 사용자 연결 해제: " + userId);
    }

    @SuppressWarnings("null")
    @Override
    public void handleTransportError(WebSocketSession session, Throwable exception) throws Exception {
        System.err.println("⚠️ 오류 발생: " + exception.getMessage());
    }

}