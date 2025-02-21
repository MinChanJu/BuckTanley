class User {
  final int? id;
  final String userId;
  final String userPw;
  final String name;
  final String phone;
  final String email;
  final String? image;
  final String introduction;
  final int age;
  final bool gender;
  final int status;
  final DateTime createdAt;

  User({
    required this.id,
    required this.userId,
    required this.userPw,
    required this.name,
    required this.phone,
    required this.email,
    required this.image,
    required this.introduction,
    required this.age,
    required this.gender,
    required this.status,
    required this.createdAt,
  });

  // JSON -> 객체 변환
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      userId: json['userId'],
      userPw: json['userPw'],
      name: json['name'],
      phone: json['phone'],
      email: json['email'],
      image: json['image'],
      introduction: json['introduction'],
      age: json['age'],
      gender: json['gender'],
      status: json['status'],
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
      'userId': userId,
      'userPw': userPw,
      'name': name,
      'phone': phone,
      'email': email,
      'image': image,
      'introduction': introduction,
      'age': age,
      'gender': gender,
      'status': status,
      'createdAt': '$formatted$zoneSuffix',
    };
  }
}
