package com.example.buck_tanley.repository;

import java.util.List;
import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.example.buck_tanley.domain.entity.FcmToken;

@Repository
public interface FcmTokenRepository extends JpaRepository<FcmToken, Long> {
  List<FcmToken> findAllByUserId(String userId);

  Optional<FcmToken> findByUserIdAndPlatform(String userId, String platform);

  void deleteByUserId(String userId);

  void deleteByUserIdAndPlatform(String userId, String platform);
}
