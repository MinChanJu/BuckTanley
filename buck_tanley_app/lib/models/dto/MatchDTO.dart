import 'package:buck_tanley_app/SetUp.dart';

class MatchDTO {
  final String status;
  final UserDTO user1;
  final UserDTO user2;

  MatchDTO({
    required this.status,
    required this.user1,
    required this.user2,
  });

  // JSON -> 객체 변환
  factory MatchDTO.fromJson(Map<String, dynamic> json) {
    return MatchDTO(
      status: json['status'],
      user1: UserDTO.fromJson(json['user1']),
      user2: UserDTO.fromJson(json['user2']),
    );
  }

  // 객체 -> JSON 변환
  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'user1': user1.toJson(),
      'user2': user2.toJson(),
    };
  }
}
