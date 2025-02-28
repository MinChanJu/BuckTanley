package com.example.buck_tanley.handler;

import org.springframework.http.server.ServerHttpRequest;
import org.springframework.http.server.ServerHttpResponse;
import org.springframework.web.socket.WebSocketHandler;
import org.springframework.web.socket.server.HandshakeInterceptor;

import java.util.Map;

public class UserHandshakeInterceptor implements HandshakeInterceptor {

    @SuppressWarnings("null")
    @Override
    public boolean beforeHandshake(ServerHttpRequest request, ServerHttpResponse response,
                                    WebSocketHandler wsHandler, Map<String, Object> attributes) {
        // 쿼리 파라미터에서 userId 가져와 attributes에 저장
        String query = request.getURI().getQuery();
        if (query != null) {
            System.out.println("query: " + query);
            String[] queryArray = query.split("&");
            for (String q : queryArray) {
                String[] keyValue = q.split("=");
                attributes.put(keyValue[0], keyValue[1]);
            }
        }
        return true;
    }

    @SuppressWarnings("null")
    @Override
    public void afterHandshake(ServerHttpRequest request, ServerHttpResponse response,
                                WebSocketHandler wsHandler, Exception exception) {
        // 핸드셰이크 후 로직 (필요 시 구현)
    }
}