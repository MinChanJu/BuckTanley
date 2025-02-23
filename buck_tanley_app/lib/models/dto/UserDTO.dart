import 'package:buck_tanley_app/models/entity/User.dart';

class UserDTO {
  final String userId;
  final String nickname;
  final String? image;
  final String introduction;
  final bool gender;
  final int age;
  final int status;

  UserDTO({
    required this.userId,
    required this.nickname,
    required this.image,
    required this.introduction,
    required this.gender,
    required this.age,
    required this.status,
  });

  factory UserDTO.init(String userId) {
    return UserDTO(
      userId: userId,
      nickname: "",
      image: null,
      introduction: "",
      gender: false,
      age: 20,
      status: 2,
    );
  }

  factory UserDTO.fromUser(User? user) {
    if (user == null) {
      return UserDTO.init("");
    }
    return UserDTO(
      userId: user.userId,
      nickname: user.nickname,
      image: user.image,
      introduction: user.introduction,
      gender: user.gender,
      age: user.age,
      status: user.status,
    );
  }

  // JSON -> 객체 변환
  factory UserDTO.fromJson(Map<String, dynamic> json) {
    return UserDTO(
      userId: json['userId'],
      nickname: json['nickname'],
      image: json['image'],
      introduction: json['introduction'],
      gender: json['gender'],
      age: json['age'],
      status: json['status'],
    );
  }

  // 객체 -> JSON 변환
  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'nickname': nickname,
      'image': image,
      'introduction': introduction,
      'gender': gender,
      'age': age,
      'status': status,
    };
  }
}
