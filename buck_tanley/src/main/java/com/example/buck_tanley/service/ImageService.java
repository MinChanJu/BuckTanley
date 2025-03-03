package com.example.buck_tanley.service;

import java.io.IOException;
import java.util.Base64;

import org.springframework.http.*;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;
import org.springframework.web.multipart.MultipartFile;

import com.example.buck_tanley.exception.CustomException;
import com.example.buck_tanley.exception.ErrorCode;
import com.google.api.client.util.Value;

@Service
public class ImageService {

  @Value("${SUPABASE_URL}")
  private String SUPABASE_URL;
  @Value("${SUPABASE_BUCKET}")
  private String SUPABASE_BUCKET;
  @Value("${SUPABASE_API_KEY}")
  private String SUPABASE_API_KEY;

  public String uploadImage(MultipartFile imageFile, String userId) {
    try {
      RestTemplate restTemplate = new RestTemplate();
      HttpHeaders headers = new HttpHeaders();
      headers.set("apikey", SUPABASE_API_KEY);
      headers.set("Authorization", "Bearer " + SUPABASE_API_KEY);
      headers.setContentType(MediaType.APPLICATION_OCTET_STREAM);

      // 파일명 중복 방지
      String fileName = userId + "_" + System.currentTimeMillis() + "_" + imageFile.getOriginalFilename();
      String uploadUrl = SUPABASE_URL + "/storage/v1/object/" + SUPABASE_BUCKET + "/" + fileName;

      // Supabase Storage로 파일 업로드
      HttpEntity<byte[]> requestEntity = new HttpEntity<>(imageFile.getBytes(), headers);
      ResponseEntity<String> response = restTemplate.exchange(uploadUrl, HttpMethod.PUT, requestEntity, String.class);

      if (response.getStatusCode().is2xxSuccessful()) {
        // ✅ Supabase CDN URL 반환
        return SUPABASE_URL + "/storage/v1/object/public/" + SUPABASE_BUCKET + "/" + fileName;
      } else {
        System.out.println("❌ 업로드 실패: " + response.getBody());
        throw new CustomException(ErrorCode.IMAGE_UPLOAD_FAILED);
      }
    } catch (IOException e) {
      System.out.println("❌ 파일 처리 중 오류 발생: " + e.getMessage());
      throw new CustomException(ErrorCode.IMAGE_UPLOAD_FAILED);
    }
  }

  public String uploadImage(String base64Image, String userId) {
    try {
      // ✅ Base64 -> Byte 변환
      byte[] decodedBytes = Base64.getDecoder().decode(base64Image);

      // ✅ Supabase Storage 업로드
      RestTemplate restTemplate = new RestTemplate();
      HttpHeaders headers = new HttpHeaders();
      headers.set("apikey", SUPABASE_API_KEY);
      headers.set("Authorization", "Bearer " + SUPABASE_API_KEY);
      headers.setContentType(MediaType.APPLICATION_OCTET_STREAM);

      String fileName = userId + "_" + System.currentTimeMillis() + "_" + "profile.png";
      String uploadUrl = SUPABASE_URL + "/storage/v1/object/" + SUPABASE_BUCKET + "/" + fileName;

      HttpEntity<byte[]> requestEntity = new HttpEntity<>(decodedBytes, headers);
      ResponseEntity<String> response = restTemplate.exchange(uploadUrl, HttpMethod.PUT, requestEntity, String.class);

      if (response.getStatusCode().is2xxSuccessful()) {
        // ✅ 업로드된 이미지 URL 반환
        return SUPABASE_URL + "/storage/v1/object/public/" + SUPABASE_BUCKET + "/" + fileName;
      } else {
        System.out.println("❌ 업로드 실패: " + response.getBody());
        throw new CustomException(ErrorCode.IMAGE_UPLOAD_FAILED);
      }

    } catch (Exception e) {
      System.out.println("❌ 파일 처리 중 오류 발생: " + e.getMessage());
      throw new CustomException(ErrorCode.IMAGE_UPLOAD_FAILED);
    }
  }
}
