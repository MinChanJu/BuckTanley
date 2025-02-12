import 'package:flutter/material.dart';

class AdBanner extends StatelessWidget {
  const AdBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[300],
      height: 100,
      width: double.infinity,
      alignment: Alignment.center,
      child: const Text('광고'),
    );
  }
}