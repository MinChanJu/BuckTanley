package com.example.buck_tanley.config;

import org.springframework.context.annotation.Configuration;
import org.springframework.web.socket.config.annotation.*;

import com.example.buck_tanley.handler.ChatWebSocketHandler;
import com.example.buck_tanley.handler.MatchWebSocketHandler;
import com.example.buck_tanley.handler.UserHandshakeInterceptor;

@Configuration
@EnableWebSocket
public class WebSocketConfig implements WebSocketConfigurer {

    private final ChatWebSocketHandler chatWebSocketHandler;
    private final MatchWebSocketHandler matchWebSocketHandler;

    // 생성자를 통한 DI
    public WebSocketConfig(ChatWebSocketHandler chatWebSocketHandler, MatchWebSocketHandler matchWebSocketHandler) {
        this.chatWebSocketHandler = chatWebSocketHandler;
        this.matchWebSocketHandler = matchWebSocketHandler;
    }

    @Override
    public void registerWebSocketHandlers(@SuppressWarnings("null") WebSocketHandlerRegistry registry) {
        registry.addHandler(chatWebSocketHandler, "/chat")
                .addInterceptors(new UserHandshakeInterceptor())
                .setAllowedOrigins("*");

        registry.addHandler(matchWebSocketHandler, "/match")
                .addInterceptors(new UserHandshakeInterceptor())
                .setAllowedOrigins("*");
    }
}