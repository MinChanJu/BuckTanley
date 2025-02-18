package com.example.buck_tanley.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import com.example.buck_tanley.domain.dto.ApiResponse;
import com.example.buck_tanley.domain.entity.Match;
import com.example.buck_tanley.service.MatchService;

import java.util.List;

@RestController
@RequestMapping("/api/matching")
public class MatchController {

    @Autowired
    private MatchService matchService;

    @GetMapping("/all")
    public ResponseEntity<ApiResponse<List<Match>>> getAllMatches(@RequestParam String userId) {
        List<Match> matches = matchService.getAllMatchByUserId(userId);
        ApiResponse<List<Match>> response = new ApiResponse<>(200, true, "매칭 리스트 조회 성공", matches);
        return ResponseEntity.status(HttpStatus.OK).body(response);
    }

    @PostMapping("/request")
    public ResponseEntity<ApiResponse<Match>> createMatch(@RequestParam String userId1, @RequestParam String userId2) {
        Match match = matchService.createMatch(userId1, userId2);
        ApiResponse<Match> response = new ApiResponse<>(201, true, "매칭 요청 성공", match);
        return ResponseEntity.status(HttpStatus.OK).body(response);
    }

    @PutMapping("/accept")
    public ResponseEntity<ApiResponse<Match>> updateMatch(@RequestBody Match match) {
        Match updatedMatch = matchService.updateMatch(match.getId());
        ApiResponse<Match> response = new ApiResponse<>(200, true, "매칭 수락 성공", updatedMatch);
        return ResponseEntity.status(HttpStatus.OK).body(response);
    }

    @DeleteMapping("/delete")
    public ResponseEntity<ApiResponse<Void>> deleteMatch(@RequestParam Match match) {
        matchService.deleteMatch(match.getId());
        ApiResponse<Void> response = new ApiResponse<>(200, true, "매칭 삭제 성공", null);
        return ResponseEntity.status(HttpStatus.OK).body(response);
    }

}
