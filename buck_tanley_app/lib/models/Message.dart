class Message {
  final int? id;
  final String sender;
  final String receiver;
  final String content;
  final DateTime createdAt;

  Message({
    required this.id,
    required this.sender,
    required this.receiver,
    required this.content,
    required this.createdAt,
  });

  // JSON -> 객체 변환
  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      id: json['id'],
      sender: json['sender'],
      receiver: json['receiver'],
      content: json['content'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  // 객체 -> JSON 변환
  Map<String, dynamic> toJson() {
    String formatted = createdAt.toIso8601String();
    String offset = createdAt.timeZoneOffset.inHours.toString().padLeft(2, '0');
    String zoneSuffix = createdAt.timeZoneOffset.isNegative ? '-$offset:00' : '+$offset:00';
    return {
      'id': id,
      'sender': sender,
      'receiver': receiver,
      'content': content,
      'createdAt': '$formatted$zoneSuffix',
    };
  }
}
