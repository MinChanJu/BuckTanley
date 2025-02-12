class Message {
  final String message;
  final int type;
  final DateTime time;

  Message({
    required this.message,
    required this.type,
    required this.time,
  });

  // JSON -> 객체 변환
  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      message: json['message'],
      type: json['type'],
      time: json['time'],
    );
  }

  // 객체 -> JSON 변환
  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'type': type,
      'time': time,
    };
  }
}