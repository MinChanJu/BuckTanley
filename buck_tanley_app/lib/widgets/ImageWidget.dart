import 'package:flutter/material.dart';

class ImageWidget extends StatelessWidget {
  final ImageProvider imageProvider;
  const ImageWidget({super.key, required this.imageProvider});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      child: InteractiveViewer(
        minScale: 1.0,
        maxScale: 3.0,
        child: Image(
          image: imageProvider,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
