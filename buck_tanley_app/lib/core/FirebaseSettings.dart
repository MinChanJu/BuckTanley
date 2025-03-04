import 'package:firebase_core/firebase_core.dart' show Firebase, FirebaseOptions;
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart' show TargetPlatform, Uint8List, defaultTargetPlatform, kIsWeb;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;

class FirebaseSettings {
  static FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  static String? fcmToken;

  static Future<void> init() async {
    try {
      await Firebase.initializeApp(
        options: currentPlatform,
      );

      fcmToken = await FirebaseMessaging.instance.getToken();
      print("📩 FCM Token: $fcmToken"); // ✅ 서버로 전송 필요

      const AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');

      const InitializationSettings initializationSettings = InitializationSettings(android: initializationSettingsAndroid);

      await flutterLocalNotificationsPlugin.initialize(initializationSettings);

      FirebaseMessaging.onBackgroundMessage((RemoteMessage message) => _firebaseMessagingHandler(message, false));
      FirebaseMessaging.onMessage.listen((RemoteMessage message) => _firebaseMessagingHandler(message, true));
      FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) => _firebaseMessagingHandler(message, true));

      print("📩 Firebase 설정 완료");
    } catch (e) {
      print("📩 Firebase 설정 실패: $e");
    }
  }

  static Future<void> _firebaseMessagingHandler(RemoteMessage message, bool foreground) async {
    String? imageUrl = message.data['image']; // ✅ 서버에서 보낸 이미지 URL 가져오기

    BigPictureStyleInformation? bigPictureStyle;

    if (imageUrl != null && imageUrl.isNotEmpty) {
      try {
        // ✅ 이미지 다운로드 후 `bigPicture`로 설정
        final response = await http.get(Uri.parse(imageUrl));
        if (response.statusCode == 200) {
          Uint8List imageBytes = response.bodyBytes;
          bigPictureStyle = BigPictureStyleInformation(
            ByteArrayAndroidBitmap(imageBytes),
            contentTitle: message.notification?.title ?? 'New Message',
            summaryText: message.notification?.body ?? '',
          );
        }
      } catch (e) {
        print("❌ 이미지 다운로드 실패: $e");
      }
    }

    AndroidNotificationDetails androidPlatformChannelSpecifics = AndroidNotificationDetails(
      '${foreground ? "foreground" : "background"}_channel',
      '${foreground ? "Foreground" : "Background"} Notifications',
      channelDescription: 'Notifications from ${foreground ? "foreground" : "background"} messages',
      importance: Importance.max,
      priority: Priority.high,
      styleInformation: bigPictureStyle,
    );

    NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
    );

    await flutterLocalNotificationsPlugin.show(
      0,
      message.notification?.title ?? 'Background Notification',
      message.notification?.body ?? '',
      platformChannelSpecifics,
      payload: message.data.toString(),
    );

    print("📩 ${foreground ? "Foreground" : "Background"} FCM 메시지 받음: ${message.messageId}");
    print("📩 알림 제목: ${message.notification?.title}");
    print("📩 알림 내용: ${message.notification?.body}");
    print("📩 데이터: ${message.data}");
    print("📩 이미지: $imageUrl");
  }

  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        return windows;
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyCrVBpLGX_8uCqFBv7l4LBKHflrlaWqUWo',
    appId: '1:50507627449:web:3db5b61d3b7e11404a5468',
    messagingSenderId: '50507627449',
    projectId: 'bucktanley-50089',
    authDomain: 'bucktanley-50089.firebaseapp.com',
    storageBucket: 'bucktanley-50089.firebasestorage.app',
    measurementId: 'G-VG7D029W23',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAjasIvnqSVMdWjPNMCiCaMyboMFNiRV28',
    appId: '1:50507627449:android:df5a99e6058d51f44a5468',
    messagingSenderId: '50507627449',
    projectId: 'bucktanley-50089',
    storageBucket: 'bucktanley-50089.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDtiIg54bDO1GVLBpL7PCXWBNTz085jsFU',
    appId: '1:50507627449:ios:bd013c420c8089674a5468',
    messagingSenderId: '50507627449',
    projectId: 'bucktanley-50089',
    storageBucket: 'bucktanley-50089.firebasestorage.app',
    iosBundleId: 'com.example.buckTanleyApp',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDtiIg54bDO1GVLBpL7PCXWBNTz085jsFU',
    appId: '1:50507627449:ios:bd013c420c8089674a5468',
    messagingSenderId: '50507627449',
    projectId: 'bucktanley-50089',
    storageBucket: 'bucktanley-50089.firebasestorage.app',
    iosBundleId: 'com.example.buckTanleyApp',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyCrVBpLGX_8uCqFBv7l4LBKHflrlaWqUWo',
    appId: '1:50507627449:web:0f03d7f25689d9134a5468',
    messagingSenderId: '50507627449',
    projectId: 'bucktanley-50089',
    authDomain: 'bucktanley-50089.firebaseapp.com',
    storageBucket: 'bucktanley-50089.firebasestorage.app',
    measurementId: 'G-7QVGP8H5KN',
  );
}
