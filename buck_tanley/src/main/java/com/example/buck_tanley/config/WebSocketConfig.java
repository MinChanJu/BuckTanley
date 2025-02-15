package com.example.buck_tanley.config;

import org.springframework.context.annotation.Configuration;
import org.springframework.web.socket.config.annotation.*;

import com.example.buck_tanley.handler.ChatHandler;

@Configuration
@EnableWebSocket
public class WebSocketConfig implements WebSocketConfigurer {
    @Override
    public void registerWebSocketHandlers(@SuppressWarnings("null") WebSocketHandlerRegistry registry) {
        registry.addHandler(new ChatHandler(), "/chat")
                .addInterceptors(new UserHandshakeInterceptor())
                .setAllowedOrigins("*");
    }
}