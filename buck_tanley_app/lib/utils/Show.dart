import 'package:buck_tanley_app/core/Import.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

class Show {
  static SnackbarController? _currentSnackbar;

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

  static void snackbarTop(String title, String message, String? imageUrl) {
    final context = getIt<GlobalKey<NavigatorState>>().currentContext;
    if (context != null) {
      _currentSnackbar?.close(withAnimations: false);
      _currentSnackbar = null;
      _currentSnackbar = Get.rawSnackbar(
        titleText: Text(title, style: const TextStyle(fontSize: 20, color: Colors.black)),
        messageText: Text(message, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 15, color: Colors.black)),
        icon: ProfileAvatarWidget(imageUrl: imageUrl),
        overlayColor: Colors.black,
        backgroundColor: const Color.fromARGB(200, 125, 125, 125),
        snackPosition: SnackPosition.TOP, // ✅ 상단에 표시
        margin: EdgeInsets.only(top: 20),
        padding: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
        maxWidth: MediaQuery.of(context).size.width * 0.8,
        borderRadius: 8,
        duration: Duration(seconds: 3),
        animationDuration: Duration(milliseconds: 200),
        isDismissible: false,
        instantInit: true,
      );
    } else {
      print("❌ Snackbar를 표시할 수 없습니다. context가 null입니다.");
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
    UserInfo? partner,
    bool? partnerRandom,
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
              if (partner != null && partnerRandom != null)
                TextButton(
                  onPressed: () => Navigate.pushFriendDetail(partner, partnerRandom),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 20,
                        backgroundImage: partner.image,
                        backgroundColor: const Color.fromARGB(255, 209, 209, 209),
                      ),
                      const SizedBox(width: 10),
                      Text(partner.user.nickname),
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
