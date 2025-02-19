package com.example.buck_tanley.exception;

import org.springframework.http.HttpStatus;

import lombok.Getter;

@Getter
public enum ErrorCode {
    INVALID_PASSWORD_ALP(HttpStatus.BAD_REQUEST, "비밀번호에 알파벳이 포함되지 않았습니다."),
    INVALID_PASSWORD_NUM(HttpStatus.BAD_REQUEST, "비밀번호에 숫자가 포함되지 않았습니다."),
    INVALID_PASSWORD_SPE(HttpStatus.BAD_REQUEST, "비밀번호에 알파벳과 숫자를 제외한 다른 문자가 포함되었습니다."),
    INVALID_PASSWORD_LEN(HttpStatus.BAD_REQUEST, "비밀번호의 길이가 8자 미만입니다."),
    INVALID_CREDENTIALS(HttpStatus.BAD_REQUEST, "아이디가 틀리거나 비밀번호가 틀립니다."),

    DUPLICATE_USER_ID(HttpStatus.CONFLICT, "이미 존재하는 사용자 ID입니다."),
    USER_NOT_FOUND(HttpStatus.NOT_FOUND, "사용자를 찾을 수 없습니다."),

    MESSAGE_NOT_FOUND(HttpStatus.NOT_FOUND, "메시지를 찾을 수 없습니다."),

    MATCH_NOT_FOUND(HttpStatus.NOT_FOUND, "메시지를 찾을 수 없습니다.");

    private final HttpStatus status;
    private final String message;

    ErrorCode(HttpStatus status, String message) {
        this.status = status;
        this.message = message;
    }
}
