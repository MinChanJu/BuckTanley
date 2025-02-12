class Chat {
  final String image;
  final String name;
  final String last;
  final String time;

  Chat({
    required this.image,
    required this.name,
    required this.last,
    required this.time,
  });

  // JSON -> 객체 변환
  factory Chat.fromJson(Map<String, dynamic> json) {
    return Chat(
      image: json['image'],
      name: json['name'],
      last: json['last'],
      time: json['time'],
    );
  }

  // 객체 -> JSON 변환
  Map<String, dynamic> toJson() {
    return {
      'image': image,
      'name': name,
      'last': last,
      'time': time,
    };
  }
}