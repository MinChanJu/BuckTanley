class Chat {
  final String image;
  final String name;
  final String userId;
  final String time;

  Chat({
    required this.image,
    required this.name,
    required this.userId,
    required this.time,
  });

  // JSON -> 객체 변환
  factory Chat.fromJson(Map<String, dynamic> json) {
    return Chat(
      image: json['image'],
      name: json['name'],
      userId: json['userId'],
      time: json['time'],
    );
  }

  // 객체 -> JSON 변환
  Map<String, dynamic> toJson() {
    return {
      'image': image,
      'name': name,
      'userId': userId,
      'time': time,
    };
  }
}