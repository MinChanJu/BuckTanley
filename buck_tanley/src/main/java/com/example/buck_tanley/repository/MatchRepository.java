package com.example.buck_tanley.repository;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.example.buck_tanley.domain.entity.Match;

@Repository
public interface MatchRepository extends JpaRepository<Match, Long> {
    boolean existsByUserId1AndUserId2(String userId1, String userId2);

    List<Match> findAllByUserId1(String userId1);

    List<Match> findAllByUserId2(String userId2);
}
