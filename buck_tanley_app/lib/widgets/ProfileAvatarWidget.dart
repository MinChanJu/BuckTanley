import 'package:buck_tanley_app/utils/ImageConverter.dart';
import 'package:flutter/material.dart';

class ProfileAvatarWidget extends StatelessWidget {
  final String? imageUrl;
  final double radius;

  const ProfileAvatarWidget({super.key, required this.imageUrl, this.radius = 25});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<ImageProvider>(
      future: ImageConverter.loadNetworkImage(imageUrl), // ✅ 네트워크 이미지 로딩
      builder: (context, snapshot) {
        return Stack(
          alignment: Alignment.center,
          children: [
            CircleAvatar(
              radius: radius,
              backgroundColor: Colors.grey[800], // ✅ 기본 배경
              backgroundImage: snapshot.hasData ? snapshot.data : null, // ✅ 로드된 이미지 적용
              child: snapshot.connectionState == ConnectionState.waiting
                  ? Padding(
                      padding: EdgeInsets.all(radius * 2 / 3),
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    ) // ✅ 로딩 중 표시
                  : null, // ✅ 이미지가 로드되면 제거
            ),
            if (snapshot.hasError) // ❌ 오류 발생 시 에러 아이콘 표시
              CircleAvatar(
                radius: radius,
                backgroundColor: Colors.red,
                child: Icon(Icons.error, color: Colors.white),
              ),
          ],
        );
      },
    );
  }
}
