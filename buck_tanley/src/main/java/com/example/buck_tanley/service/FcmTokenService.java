package com.example.buck_tanley.service;

import java.io.IOException;
import java.time.ZonedDateTime;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.core.io.ClassPathResource;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;

import com.example.buck_tanley.domain.entity.FcmToken;
import com.example.buck_tanley.repository.FcmTokenRepository;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.google.auth.oauth2.GoogleCredentials;


import org.springframework.http.*;

@Service
public class FcmTokenService {

  @Autowired
  private FcmTokenRepository fcmTokenRepository;
  @Value("${FCM_URL}")
  private String FCM_URL;
  private final ObjectMapper objectMapper = new ObjectMapper();

  // ✅ Firebase 서버 키 가져오기
  private String getAccessToken() throws IOException {
    GoogleCredentials googleCredentials = GoogleCredentials
        .fromStream(new ClassPathResource("firebase-adminsdk.json").getInputStream())
        .createScoped("https://www.googleapis.com/auth/cloud-platform");
    googleCredentials.refreshIfExpired();
    return googleCredentials.getAccessToken().getTokenValue();
  }

  // ✅ 특정 기기로 메시지 전송
  public void sendMessageToToken(String userId, String title, String body, String imageUrl) throws IOException {
    List<FcmToken> fcmToken = fcmTokenRepository.findAllByUserId(userId);
    if (fcmToken.isEmpty()) {
      System.out.println("No token found");
      return;
    }
    String accessToken = getAccessToken();
    for (FcmToken token : fcmToken) {
      Map<String, Object> message = new HashMap<>();
      message.put("token", token.getToken());
      message.put("notification", Map.of("title", title, "body", body));
      message.put("data", Map.of("image", imageUrl));

      Map<String, Object> requestBody = Map.of("message", message);
      String jsonBody = objectMapper.writeValueAsString(requestBody);

      HttpHeaders headers = new HttpHeaders();
      headers.setBearerAuth(accessToken);
      headers.setContentType(MediaType.APPLICATION_JSON);

      HttpEntity<String> request = new HttpEntity<>(jsonBody, headers);
      System.out.println(FCM_URL);
      RestTemplate restTemplate = new RestTemplate();
      restTemplate.exchange(FCM_URL, HttpMethod.POST, request, String.class);
    }
    System.out.println("Message sent");
  }

  public FcmToken createFcmToken(String userId, String platform, String token) {
    if (userId == null || platform == null || token == null) {
      return null;
    }
    Optional<FcmToken> findFcmToken = fcmTokenRepository.findByUserIdAndPlatform(userId, platform);
    if (findFcmToken.isPresent()) {
      FcmToken fcmToken = findFcmToken.get();
      fcmToken.setToken(token);
      fcmToken.setCreatedAt(ZonedDateTime.now());
      return fcmTokenRepository.save(fcmToken);
    }
    FcmToken fcmToken = new FcmToken(null, userId, platform, token, ZonedDateTime.now());
    return fcmTokenRepository.save(fcmToken);
  }

  public void deleteFcmToken(String userId, String platform) {
    fcmTokenRepository.deleteByUserIdAndPlatform(userId, platform);
  }

  public void deleteAllFcmToken(String userId) {
    fcmTokenRepository.deleteByUserId(userId);
  }

}
