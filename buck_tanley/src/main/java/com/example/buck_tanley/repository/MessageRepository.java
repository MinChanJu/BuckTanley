package com.example.buck_tanley.repository;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import com.example.buck_tanley.domain.entity.Message;

@Repository
public interface MessageRepository extends JpaRepository<Message, Long> {
  @Query("SELECT m FROM Message m WHERE m.sender = ?1 OR m.receiver = ?1 ORDER BY m.createdAt")
  List<Message> findAllByUserId(String userId);

  List<Message> findAllBySender(String sender);

  List<Message> findAllByReceiver(String receiver);
}