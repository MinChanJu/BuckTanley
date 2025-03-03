import 'dart:async';
import 'dart:io';

import 'package:buck_tanley_app/core/Import.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImageConverter {
  static ImageProvider defaultImage = AssetImage("assets/images/BuckTanleyLogo.png");

  /// 📸 이미지 선택 (웹/모바일 환경 모두 지원)
  static Future<Imager?> pickImage() async {
    try {
      final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        if (kIsWeb) {
          final Uint8List imager = await pickedFile.readAsBytes();
          return Imager(webImage: imager, mobileImage: null);
        } else {
          final File imager = File(pickedFile.path);
          return Imager(webImage: null, mobileImage: imager);
        }
      }
    } catch (e) {
      print('❌ 이미지 선택 실패');
    }
    return null;
  }

  static ImageProvider getImage(Imager? image) {
    if (image == null) {
      return defaultImage;
    }

    if (kIsWeb) {
      return image.webImage != null ? MemoryImage(image.webImage!) : defaultImage;
    } else {
      return image.mobileImage != null ? FileImage(image.mobileImage!) : defaultImage;
    }
  }

  static ImageProvider getImageNetwork(String? imagePath) {
    if (imagePath == null) {
      return defaultImage;
    }

    return Image.network(imagePath).image;
  }

  static Future<ImageProvider> loadNetworkImage(String? url) async {
    if (url == null) {
      return defaultImage;
    }
    final completer = Completer<ImageProvider>();
    final image = NetworkImage(url);
    final listener = ImageStreamListener((ImageInfo info, bool synchronousCall) {
      completer.complete(image);
    }, onError: (dynamic error, StackTrace? stackTrace) {
      completer.completeError(error);
    });
    image.resolve(ImageConfiguration()).addListener(listener);
    return completer.future;
  }
}
