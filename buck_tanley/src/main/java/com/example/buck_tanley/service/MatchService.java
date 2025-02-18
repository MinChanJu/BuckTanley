package com.example.buck_tanley.service;

import java.util.ArrayList;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.buck_tanley.domain.entity.Match;
import com.example.buck_tanley.exception.CustomException;
import com.example.buck_tanley.exception.ErrorCode;
import com.example.buck_tanley.repository.MatchRepository;

@Service
public class MatchService {

    @Autowired
    private MatchRepository matchRepository;

    public List<Match> getAllMatchByUserId(String userId) {
        List<Match> matches1 = matchRepository.findAllByUserId1(userId);
        List<Match> matches2 = matchRepository.findAllByUserId2(userId);

        List<Match> combinedMatches = new ArrayList<>(matches1);
        combinedMatches.addAll(matches2);
        return combinedMatches;
    }

    public Match createMatch(String userId1, String userId2) {
        if (matchRepository.existsByUserId1AndUserId2(userId1, userId2) ||
                matchRepository.existsByUserId1AndUserId2(userId2, userId1)) {
            throw new CustomException(ErrorCode.USER_NOT_FOUND);
        }

        Match match = new Match();
        match.setUserId1(userId1);
        match.setUserId2(userId2);
        match.setStatus((short) 0); // 매칭 요청
        return matchRepository.save(match);
    }

    public Match updateMatch(Long matchId) {
        Match match = matchRepository.findById(matchId).orElseThrow(() -> new CustomException(ErrorCode.MATCH_NOT_FOUND));
        match.setStatus((short) 1); // 매칭 수락
        return matchRepository.save(match);
    }

    public void deleteMatch(Long matchId) {
        if (matchId == null) throw new CustomException(ErrorCode.MATCH_NOT_FOUND);
        if (!matchRepository.existsById(matchId)) throw new CustomException(ErrorCode.MATCH_NOT_FOUND);
        matchRepository.deleteById(matchId);
    }
}
