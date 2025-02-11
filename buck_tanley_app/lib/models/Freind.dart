class Freind {
  final String image;
  final String name;
  final String message;
  final int status;

  Freind({
    required this.image,
    required this.name,
    required this.message,
    required this.status,
  });

  // JSON -> 객체 변환 (Spring API 응답을 받았을 때)
  factory Freind.fromJson(Map<String, dynamic> json) {
    return Freind(
      image: json['image'],
      name: json['name'],
      message: json['message'],
      status: json['status'],
    );
  }

  // 객체 -> JSON 변환 (Spring API에 요청 보낼 때)
  Map<String, dynamic> toJson() {
    return {
      'image': image,
      'name': name,
      'message': message,
      'status': status,
    };
  }
}