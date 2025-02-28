import 'dart:io';

import 'package:buck_tanley_app/SetUp.dart';
import 'package:flutter/foundation.dart';

class Server {
  static String get ip {
    if (kIsWeb) {
      return "localhost"; // 웹 전용 주소
    } else if (Platform.isAndroid) {
      return "10.0.2.2"; // Android 에뮬레이터 전용 주소
    } else {
      return "localhost"; // 기본 주소
    }
  }

  static String get port {
      return ":8080"; // 포트 번호
  }

  static String get platform {
    if (kIsWeb) {
      return "web"; // 웹
    } else {
      return Platform.operatingSystem; // 안드로이드, iOS, macOS, Windows, Linux
    }
  }

  /// 0 - match / 1 - chat / 2 - random
  static String type(int index) {
    switch (index) {
      case 0:
        return "match";
      case 1:
        return "chat";
      case 2:
        return "random";
      default:
        return "";
    }
  }

  static String get baseUrl => "http://$ip$port";
  
  static String get apiUrl => "http://$ip$port/api";

  static String get userUrl => "http://$ip$port/api/users";
  static String get messageUrl => "http://$ip$port/api/messages";
  static String get friendUrl => "http://$ip$port/api/friends";

  static String wsUrl(String type) {
    final String query = "userId=${getIt<UserProvider>().userId}&platform=$platform&type=$type";
    if (type == "chat" || type == "random") return "$chatWS?$query";
    if (type == "match") return "$matchWS?$query";
    return "";
  }

  static String chatWS = "ws://$ip$port/chat";
  static String matchWS = "ws://$ip$port/match";

  static Map<String, String> header = {
    'Accept': 'application/json; charset=UTF-8',
    'Content-Type': 'application/json; charset=UTF-8',
  };
}
