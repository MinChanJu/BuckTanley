class Message {
  final String message;
  final int type;
  final String time;

  Message({
    required this.message,
    required this.type,
    required this.time,
  });

  // JSON -> 객체 변환 (Spring API 응답을 받았을 때)
  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      message: json['message'],
      type: json['type'],
      time: json['time'],
    );
  }

  // 객체 -> JSON 변환 (Spring API에 요청 보낼 때)
  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'type': type,
      'time': time,
    };
  }
}