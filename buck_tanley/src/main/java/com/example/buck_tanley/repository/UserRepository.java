package com.example.buck_tanley.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import com.example.buck_tanley.domain.entity.User;

import java.util.Optional;

@Repository
public interface UserRepository extends JpaRepository<User, Long> {
    boolean existsByUserId(String userId);

    Optional<User> findByUserId(String userId);

    Optional<User> findByUserIdAndUserPw(String userId, String userPw);

    @Modifying
    @Transactional
    @Query("UPDATE User u SET u.status = ?2 WHERE u.userId = ?1")
    int updateUserStatus(String userId, short status);
}