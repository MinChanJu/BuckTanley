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
@Table(name = "fcm_tokens")
public class FcmToken {
    @Id @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "user_id", columnDefinition = "text")
    private String userId;

    @Column(name = "platform", columnDefinition = "text")
    private String platform;

    @Column(name = "token", columnDefinition = "text")
    private String token;

    @Column(name = "created_at")
    private ZonedDateTime createdAt;
}
