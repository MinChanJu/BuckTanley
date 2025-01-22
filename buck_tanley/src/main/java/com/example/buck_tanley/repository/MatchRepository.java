package com.example.buck_tanley.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.example.buck_tanley.domain.entity.Match;

@Repository
public interface MatchRepository extends JpaRepository<Match, Long> {
}
