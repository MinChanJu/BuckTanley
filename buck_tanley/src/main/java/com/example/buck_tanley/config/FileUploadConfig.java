package com.example.buck_tanley.config;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.boot.web.servlet.MultipartConfigFactory;
import org.springframework.util.unit.DataSize;

import jakarta.servlet.MultipartConfigElement;

@Configuration
public class FileUploadConfig {

    @Bean
    public MultipartConfigElement multipartConfigElement() {
        MultipartConfigFactory factory = new MultipartConfigFactory();
        factory.setMaxFileSize(DataSize.ofMegabytes(10)); // ✅ 10MB로 설정
        factory.setMaxRequestSize(DataSize.ofMegabytes(10)); // ✅ 10MB로 설정
        return factory.createMultipartConfig();
    }
}