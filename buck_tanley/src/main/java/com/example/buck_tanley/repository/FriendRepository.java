package com.example.buck_tanley.repository;

import java.util.List;
import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import com.example.buck_tanley.domain.entity.Friend;
import com.example.buck_tanley.domain.entity.User;

@Repository
public interface FriendRepository extends JpaRepository<Friend, Long> {
    boolean existsByUserId1AndUserId2(String userId1, String userId2);

    @Query(value = """
            SELECT u.* FROM friends f
            JOIN users u ON u.user_id =
                CASE
                    WHEN f.user_id1 = :userId THEN f.user_id2
                    ELSE f.user_id1
                END
            WHERE :userId IN (f.user_id1, f.user_id2)
              AND f.status = 0
            """, nativeQuery = true)
    List<User> findAllByUserId(String userId);

    Optional<Friend> findByUserId1AndUserId2(String userId1, String userId2);
}
