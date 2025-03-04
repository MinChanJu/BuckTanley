import 'package:buck_tanley_app/core/Import.dart';
import 'package:flutter/material.dart';

class UserInfo {
  final UserDTO user;
  final ImageProvider image;

  UserInfo({
    required this.user,
    required this.image,
  });

  factory UserInfo.init(String? userId) {
    return UserInfo(
      user: UserDTO.init(userId),
      image: ImageConverter.defaultImage,
    );
  }
}