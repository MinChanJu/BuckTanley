class Message {
  final String message;
  final String sender;
  final String receiver;
  final DateTime time;

  Message({
    required this.message,
    required this.sender,
    required this.receiver,
    required this.time,
  });

  // JSON -> 객체 변환
  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      message: json['message'],
      sender: json['sender'],
      receiver: json['receiver'],
      time: DateTime.parse(json['time']),
    );
  }

  // 객체 -> JSON 변환
  Map<String, dynamic> toJson() {
    String formatted = time.toIso8601String();
    String offset = time.timeZoneOffset.inHours.toString().padLeft(2, '0');
    String zoneSuffix = time.timeZoneOffset.isNegative ? '-$offset:00' : '+$offset:00';
    return {
      'message': message,
      'sender': sender,
      'receiver': receiver,
      'time': '$formatted$zoneSuffix',
    };
  }
}
