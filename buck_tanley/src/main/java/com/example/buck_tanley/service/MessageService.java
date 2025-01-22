package com.example.buck_tanley.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.buck_tanley.domain.entity.Message;
import com.example.buck_tanley.repository.MessageRepository;

@Service
public class MessageService {
    
    @Autowired private MessageRepository messageRepository;

    public Message createrMessage(Message message) {
        return messageRepository.save(message);
    }
}
