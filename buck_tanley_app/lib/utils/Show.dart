import 'package:buck_tanley_app/SetUp.dart';
import 'package:flutter/material.dart';

class Show {
  // 스낵바 표시 메서드
  static void snackbar(String message) {
    final context = getIt<GlobalKey<NavigatorState>>().currentContext;
    if (context != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    } else {
      print('❌ Snackbar를 표시할 수 없습니다. context가 없습니다.');
    }
  }

  // 다이얼로그 표시 메서드
  static void dialog({
    required BuildContext context,
    Widget? builder,
    bool barrier = true,
    String title = "제목",
    String message = "메세지",
    List<Widget>? actions,
    UserDTO? partner,
    ImageProvider? partnerImage,
  }) {
    showDialog(
      context: context,
      barrierDismissible: barrier,
      builder: (BuildContext context) {
        if (builder != null) return builder;
        return AlertDialog(
          title: Text(title),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(message),
              const SizedBox(height: 15),
              if (partner != null && partnerImage != null)
                TextButton(
                  onPressed: () => Navigate.pushFriendDetail(partner, partnerImage),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 20,
                        backgroundImage: partnerImage,
                        backgroundColor: const Color.fromARGB(255, 209, 209, 209),
                      ),
                      const SizedBox(width: 10),
                      Text(partner.nickname),
                    ],
                  ),
                ),
            ],
          ),
          actions: actions ??
              [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('닫기'),
                ),
              ],
        );
      },
    );
  }
}
