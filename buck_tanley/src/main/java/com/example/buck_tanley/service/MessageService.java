package com.example.buck_tanley.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.buck_tanley.domain.entity.Message;
import com.example.buck_tanley.exception.CustomException;
import com.example.buck_tanley.exception.ErrorCode;
import com.example.buck_tanley.repository.MessageRepository;

@Service
public class MessageService {
    
    @Autowired private MessageRepository messageRepository;

    public List<Message> GetAllMessagesByUserId1(String userId1) {
        return messageRepository.findAllByUserId1(userId1);
    }

    public List<Message> GetAllMessagesByUserId2(String userId2) {
        return messageRepository.findAllByUserId2(userId2);
    }

    public Message CreaterMessage(Message message) {
        return messageRepository.save(message);
    }

    public Message UpdateMessage(Message message) {
        if (messageRepository.existsById(message.getId())) throw new CustomException(ErrorCode.MESSAGE_NOT_FOUND);
        return messageRepository.save(message);
    }

    public void DeleteMessage(Long id) {
        if (id == null) throw new CustomException(ErrorCode.MESSAGE_NOT_FOUND);
        if (messageRepository.existsById(id)) throw new CustomException(ErrorCode.MESSAGE_NOT_FOUND);
        messageRepository.deleteById(id);
    }
}
