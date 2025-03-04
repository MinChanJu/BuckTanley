import 'package:firebase_messaging/firebase_messaging.dart';

class PermissionSettings {
  static Future<void> init() async {
    await notification();
  }
  
  static Future<void> notification() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print("✅ 알림 권한이 허용됨");
    } else {
      print("❌ 알림 권한이 거부됨");
    }
  }
}
