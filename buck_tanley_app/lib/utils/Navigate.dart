import 'package:buck_tanley_app/SetUp.dart';
import 'package:flutter/material.dart';

class Navigate {
  static void pop() {
    final context = getIt<GlobalKey<NavigatorState>>().currentContext;
    if (context != null) {
      Navigator.pop(context);
    } else {
      print('❌ context가 없습니다.');
    }
  }

  static void pushChatList() {
    final context = getIt<GlobalKey<NavigatorState>>().currentContext;
    if (context != null) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const ChatListPage()),
      );
    } else {
      print('❌ context가 없습니다.');
    }
  }

  static void pushChatting(String sender, String receiver, bool random) {
    final context = getIt<GlobalKey<NavigatorState>>().currentContext;
    if (context != null) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ChattingPage(sender: sender, receiver: receiver, random: random)),
      );
    } else {
      print('❌ context가 없습니다.');
    }
  }
}
