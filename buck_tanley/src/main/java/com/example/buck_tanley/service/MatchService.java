package com.example.buck_tanley.service;

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

    public Match createMatch(Match match) {
        if (matchRepository.existsByUserId1AndUserId2(match.getUserId1(), match.getUserId2()) ||
                matchRepository.existsByUserId1AndUserId2(match.getUserId2(), match.getUserId1())) {
            throw new CustomException(ErrorCode.USER_NOT_FOUND);
        }
        return matchRepository.save(match);
    }
}
