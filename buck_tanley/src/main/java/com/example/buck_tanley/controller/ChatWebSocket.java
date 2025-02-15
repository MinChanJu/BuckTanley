package com.example.buck_tanley.controller;

import jakarta.websocket.*;
import jakarta.websocket.server.ServerEndpoint;

@ServerEndpoint("/chat") // WebSocket 엔드포인트
public class ChatWebSocket {

    @OnOpen
    public void onOpen(Session session) {
        System.out.println("📡 클라이언트 연결: " + session.getId());
    }

    @OnMessage
    public void onMessage(String message, Session session) {
        System.out.println("💬 메시지 수신: " + message);
        // 클라이언트에 응답 보내기
        session.getAsyncRemote().sendText("서버로부터 응답: " + message);
    }

    @OnClose
    public void onClose(Session session) {
        System.out.println("🔌 클라이언트 연결 종료: " + session.getId());
    }

    @OnError
    public void onError(Session session, Throwable throwable) {
        System.err.println("⚠️ 오류 발생: " + throwable.getMessage());
    }
}