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
@Table(name = "users")
public class User {
    @Id @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "user_id", columnDefinition = "text")
    private String userId;

    @Column(name = "user_pw", columnDefinition = "text")
    private String userPw;

    @Column(name = "nickname", columnDefinition = "text")
    private String nickname;

    @Column(name = "phone", columnDefinition = "text")
    private String phone;

    @Column(name = "email", columnDefinition = "text")
    private String email;

    @Column(name = "image", columnDefinition = "text")
    private String image;

    @Column(name = "introduction", columnDefinition = "text")
    private String introduction;

    @Column(name = "gender")
    private Boolean gender;

    @Column(name = "age")
    private Short age;

    @Column(name = "status")
    private Short status;

    @Column(name = "created_at")
    private ZonedDateTime createdAt;
}
