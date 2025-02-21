class Freind {
  final int? id;
  final String userId1;
  final String userId2;
  final int status;
  final DateTime createdAt;

  Freind({
    required this.id,
    required this.userId1,
    required this.userId2,
    required this.status,
    required this.createdAt,
  });

  // JSON -> 객체 변환
  factory Freind.fromJson(Map<String, dynamic> json) {
    return Freind(
      id: json['id'],
      userId1: json['userId1'],
      userId2: json['userId2'],
      status: json['status'],
      createdAt: json['createdAt'],
    );
  }

  // 객체 -> JSON 변환
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId1': userId1,
      'userId2': userId2,
      'status': status,
      'createdAt': createdAt,
    };
  }
}