package com.example.buck_tanley.handler;

import org.springframework.web.socket.WebSocketSession;
import org.springframework.web.socket.handler.TextWebSocketHandler;
import org.springframework.stereotype.Component;
import org.springframework.web.socket.TextMessage;

import com.example.buck_tanley.domain.entity.Message;
import com.example.buck_tanley.service.MessageService;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.SerializationFeature;
import com.fasterxml.jackson.datatype.jsr310.JavaTimeModule;

import java.util.concurrent.ConcurrentHashMap;

@Component
public class ChatWebSocketHandler extends TextWebSocketHandler {

    // 사용자별 채팅방 관리 (userId -> session)
    private final ConcurrentHashMap<String, WebSocketSession> userChatRooms = new ConcurrentHashMap<>();
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
        if (userId != null) {
            userChatRooms.put(userId, session);
            System.out.println("🔌 챗 사용자 연결: " + userId);
        } else {
            System.out.println("⚠️ 챗 사용자 ID가 전달되지 않았습니다.");
        }
    }

    @SuppressWarnings("null")
    @Override
    protected void handleTextMessage(WebSocketSession session, TextMessage textMessage) throws Exception {
        String payload = textMessage.getPayload();
        System.out.println("📨 챗 받은 메세지: " + payload);

        try {
            Message message = objectMapper.readValue(payload, Message.class);
            userChatRooms.put(message.getSender(), session);

            // 수신자에게 메시지 전송
            sendPrivateMessage(message);
        } catch (Exception e) {
            System.out.println("❌ 챗 메세지 처리 실패: " + e.getMessage());
            session.sendMessage(new TextMessage("⚠️ 챗 잘못된 메세지 형식입니다."));
        }
    }

    // 1:1 메시지 전송
    private void sendPrivateMessage(Message message) throws Exception {
        // 메시지 저장 (DB)
        messageService.createMessage(message);
        String response = objectMapper.writeValueAsString(message);

        // sender 세션으로 전송
        WebSocketSession senderSession = userChatRooms.get(message.getSender());
        senderSession.sendMessage(new TextMessage(response));

        // receiver 세션으로 전송
        WebSocketSession receiverSession = userChatRooms.get(message.getReceiver());
        if (receiverSession != null && receiverSession.isOpen()) {
            if (!message.getSender().equals(message.getReceiver())) {
                receiverSession.sendMessage(new TextMessage(response));
                System.out.println("📤 챗 메세지 전송 완료 → " + message.getReceiver() + " (웹소켓으로 전송)");
            } else {
                System.out.println("📤 챗 본인에게 메세지 전송 완료");
            }
        } else {
            System.out.println("⚠️ 쳇 수신자 세션이 없습니다: " + message.getReceiver() + " (DB로 조회 가능)");
        }
    }

    @SuppressWarnings("null")
    @Override
    public void afterConnectionClosed(WebSocketSession session, org.springframework.web.socket.CloseStatus status) {
        String userId = (String) session.getAttributes().get("userId");
        userChatRooms.remove(userId);
        System.out.println("🔌 챗 사용자 연결 해제: " + userId);
    }

    @SuppressWarnings("null")
    @Override
    public void handleTransportError(WebSocketSession session, Throwable exception) throws Exception {
        System.err.println("⚠️ 챗 오류 발생: " + exception.getMessage());
    }

}