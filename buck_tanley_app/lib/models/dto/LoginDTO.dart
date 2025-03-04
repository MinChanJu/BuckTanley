class LoginDTO {
  final String userId;
  final String userPw;
  final String platform;
  final String? fcmToken;

  LoginDTO({
    required this.userId,
    required this.userPw,
    required this.platform,
    required this.fcmToken,
  });

  // JSON -> 객체 변환
  factory LoginDTO.fromJson(Map<String, dynamic> json) {
    return LoginDTO(
      userId: json['userId'],
      userPw: json['userPw'],
      platform: json['platform'] ?? "", 
      fcmToken: json['fcmToken'],
    );
  }

  // 객체 -> JSON 변환
  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'userPw': userPw,
      'platform': platform,
      'fcmToken': fcmToken,
    };
  }
}