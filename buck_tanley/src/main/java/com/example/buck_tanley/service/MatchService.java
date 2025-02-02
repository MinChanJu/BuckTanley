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

    public List<Match> GetAllMatchByUserId(String userId) {
        List<Match> matchs1 = matchRepository.findAllByUserId1(userId);
        List<Match> matchs2 = matchRepository.findAllByUserId2(userId);

        List<Match> combinedMatches = new ArrayList<>(matchs1);
        combinedMatches.addAll(matchs2);
        return combinedMatches;
    }

    public Match CreateMatch(Match match) {
        if (matchRepository.existsByUserId1AndUserId2(match.getUserId1(), match.getUserId2()) ||
                matchRepository.existsByUserId1AndUserId2(match.getUserId2(), match.getUserId1())) {
            throw new CustomException(ErrorCode.USER_NOT_FOUND);
        }
        return matchRepository.save(match);
    }

    public Match UpdateMatch(Match match) {
        if (matchRepository.existsById(match.getId())) throw new CustomException(ErrorCode.MATCH_NOT_FOUND);
        return matchRepository.save(match);
    }

    public void DeleteMatch(Long id) {
        if (id == null) throw new CustomException(ErrorCode.MATCH_NOT_FOUND);
        if (matchRepository.existsById(id)) throw new CustomException(ErrorCode.MATCH_NOT_FOUND);
        matchRepository.deleteById(id);
    }
}
