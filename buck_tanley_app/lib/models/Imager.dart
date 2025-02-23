import 'dart:io';
import 'dart:typed_data';

class Imager {
  final Uint8List? webImage;
  final File? mobileImage;

  Imager({
    required this.webImage,
    required this.mobileImage,
  });
}