package com.example.buck_tanley.domain.entity;

import java.time.ZonedDateTime;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.Table;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@AllArgsConstructor
@NoArgsConstructor
@Getter
@Setter
@Entity
@Table(name = "messages")
public class Message {
    @Id @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "user_id1")
    private String userId1;

    @Column(name = "user_id2")
    private String userId2;

    @Column(name = "message")
    private Short message;

    @Column(name = "image")
    private Short image;

    @Column(name = "created_at")
    private ZonedDateTime createdAt;
}
