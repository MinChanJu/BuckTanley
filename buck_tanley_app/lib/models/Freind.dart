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

  // JSON -> 객체 변환
  factory Freind.fromJson(Map<String, dynamic> json) {
    return Freind(
      image: json['image'],
      name: json['name'],
      message: json['message'],
      status: json['status'],
    );
  }

  // 객체 -> JSON 변환
  Map<String, dynamic> toJson() {
    return {
      'image': image,
      'name': name,
      'message': message,
      'status': status,
    };
  }
}