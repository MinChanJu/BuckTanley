class MatchDTO {
  final bool status;
  final String userId1;
  final String userId2;

  MatchDTO({
    required this.status,
    required this.userId1,
    required this.userId2,
  });

  // JSON -> 객체 변환
  factory MatchDTO.fromJson(Map<String, dynamic> json) {
    return MatchDTO(
      status: json['status'],
      userId1: json['userId1'],
      userId2: json['userId2'],
    );
  }

  // 객체 -> JSON 변환
  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'userId1': userId1,
      'userId2': userId2,
    };
  }
}