package com.example.buck_tanley.repository;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import com.example.buck_tanley.domain.entity.Message;

@Repository
public interface MessageRepository extends JpaRepository<Message, Long> {
  @Query("SELECT m FROM Message m WHERE m.sender = :userId OR m.receiver = :userId ORDER BY m.createdAt")
  List<Message> findAllByUserId(@Param("userId") String userId);

  List<Message> findAllBySender(String sender);

  List<Message> findAllByReceiver(String receiver);
}