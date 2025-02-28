import 'package:flutter/material.dart';

class OutlineTextWidget extends StatelessWidget {
  final Text text;
  final double strokeWidth;
  final Color strokeColor;

  const OutlineTextWidget(
    this.text, {
    super.key,
    this.strokeWidth = 2,
    this.strokeColor = Colors.black,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // 외곽선 효과
        Text(
          text.data!,
          style: TextStyle(
            fontSize: text.style?.fontSize,
            fontWeight: text.style?.fontWeight,
            foreground: Paint()
              ..style = PaintingStyle.stroke
              ..strokeWidth = strokeWidth
              ..color = strokeColor,
          ),
        ),
        // 내부 텍스트
        text,
      ],
    );
  }
}
