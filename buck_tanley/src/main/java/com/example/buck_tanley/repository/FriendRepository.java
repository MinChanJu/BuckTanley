package com.example.buck_tanley.repository;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import com.example.buck_tanley.domain.entity.Friend;

@Repository
public interface FriendRepository extends JpaRepository<Friend, Long> {
    boolean existsByUserId1AndUserId2(String userId1, String userId2);

    @Query("SELECT F FROM Friend F WHERE F.user_id1 = :userId OR F.user_id2 = :userId ORDER BY F.created_at")
    List<Friend> findAllByUserId(String userId);
}
