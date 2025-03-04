// 🛠️ GetIt & instance 설정
import 'package:buck_tanley_app/core/Import.dart';
import 'package:get_it/get_it.dart';
import 'package:flutter/material.dart';

final getIt = GetIt.instance;

class GetItSettings {
  static Future<void> init() async {
    try {
      // Provider 등록
      getIt.registerSingleton<UserProvider>(UserProvider());
      getIt.registerSingleton<MessageProvider>(MessageProvider());
      getIt.registerSingleton<FriendProvider>(FriendProvider());

      // Navigator Key 등록
      getIt.registerSingleton<GlobalKey<NavigatorState>>(GlobalKey<NavigatorState>());

      await getIt<UserProvider>().loadUser();
      print("📩 GetIt 설정 완료");
    } catch (e) {
      print("📩 GetIt 설정 실패: $e");
    }
  }
}
