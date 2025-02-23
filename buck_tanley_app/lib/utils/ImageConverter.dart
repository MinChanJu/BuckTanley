import 'dart:convert';
import 'dart:io' as io;

import 'package:buck_tanley_app/SetUp.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/foundation.dart' as foundation;

class ImageConverter {
  /// 📸 이미지 선택 (웹/모바일 환경 모두 지원)
  static Future<Imager?> pickImage() async {
    try {
      final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        if (kIsWeb) {
          final Uint8List imager = await pickedFile.readAsBytes();
          return Imager(webImage: imager, mobileImage: null);
        } else {
          final io.File imager = io.File(pickedFile.path);
          return Imager(webImage: null, mobileImage: imager);
        }
      }
    } catch (e) {
      print('❌ 이미지 선택 실패');
    }
    return null;
  }

  /// 🔒 이미지 Base64 인코딩
  static String? encodeImage(Imager? imager) {
    try {
      if (imager != null) {
        if (imager.webImage != null) {
          return base64Encode(imager.webImage!);
        } else if (imager.mobileImage != null) {
          return base64Encode(imager.mobileImage!.readAsBytesSync());
        }
      }
    } catch (e) {
      print('❌ 이미지 인코딩 실패');
    }
    return null;
  }

  /// 🔓 Base64 문자열을 이미지로 디코딩 (웹: Uint8List, 모바일: io.File)
  static Imager? decodeImage(String? base64String, {String filePath = 'decoded_imager.png'}) {
    try {
      if (base64String != null && base64String.isNotEmpty) {
        Uint8List decodedBytes = base64Decode(base64String);
        if (kIsWeb) {
          Uint8List webImage = decodedBytes;
          return Imager(webImage: webImage, mobileImage: null);
        } else {
          io.File mobileImage = io.File(filePath);
          mobileImage.writeAsBytesSync(decodedBytes);
          return Imager(webImage: null, mobileImage: mobileImage);
        }
      }
    } catch (e) {
      print('❌ 이미지 디코딩 실패');
    }
    return null;
  }

  static ImageProvider getImageDecode(String? base64String) {
    Imager? image = decodeImage(base64String);
    final defaultImage = AssetImage("assets/images/BuckTanleyLogo.png");

    if (image == null) return defaultImage;

    if (foundation.kIsWeb) {
      if (image.webImage == null) return defaultImage;
      return MemoryImage(image.webImage!);
    } else {
      if (image.mobileImage == null) return defaultImage;

      return FileImage(image.mobileImage!);
    }
  }

  static ImageProvider getImage(Imager? image) {
    final defaultImage = AssetImage("assets/images/BuckTanleyLogo.png");

    if (image == null) {
      return defaultImage;
    }

    if (foundation.kIsWeb) {
      return image.webImage != null ? MemoryImage(image.webImage!) : defaultImage;
    } else {
      return image.mobileImage != null ? FileImage(image.mobileImage!) : defaultImage;
    }
  }
}
