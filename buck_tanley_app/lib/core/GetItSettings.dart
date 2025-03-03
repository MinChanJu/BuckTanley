// 🛠️ GetIt & instance 설정
import 'package:get_it/get_it.dart';
import 'package:flutter/material.dart';
import 'package:buck_tanley_app/provider/MessageProvider.dart';
import 'package:buck_tanley_app/provider/UserProvider.dart';
import 'package:buck_tanley_app/provider/FriendProvider.dart';

final getIt = GetIt.instance;

class GetItSettings {
  static Future<void> init() async {
    // Provider 등록
    getIt.registerSingleton<UserProvider>(UserProvider());
    getIt.registerSingleton<MessageProvider>(MessageProvider());
    getIt.registerSingleton<FriendProvider>(FriendProvider());

    // Navigator Key 등록
    getIt.registerSingleton<GlobalKey<NavigatorState>>(GlobalKey<NavigatorState>());

    await getIt<UserProvider>().loadUser();
    print("📩 setup 완료");
  }
}
