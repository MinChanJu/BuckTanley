class LoginDTO {
  final String userId;
  final String userPw;

  LoginDTO({
    required this.userId,
    required this.userPw,
  });

  // JSON -> 객체 변환
  factory LoginDTO.fromJson(Map<String, dynamic> json) {
    return LoginDTO(
      userId: json['userId'],
      userPw: json['userPw'],
    );
  }

  // 객체 -> JSON 변환
  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'userPw': userPw,
    };
  }
}