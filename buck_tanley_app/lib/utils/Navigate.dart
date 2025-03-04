import 'package:buck_tanley_app/core/Import.dart';
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

  static void pushChatting(UserInfo partner, bool random) {
    final context = getIt<GlobalKey<NavigatorState>>().currentContext;
    if (context != null) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ChattingPage(partner: partner, random: random)),
      );
    } else {
      print('❌ context가 없습니다.');
    }
  }

  static void pushFriendDetail(UserInfo friend, bool random) {
    final context = getIt<GlobalKey<NavigatorState>>().currentContext;
    if (context != null) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => FriendDetailPage(friend: friend, random: random)),
      );
    } else {
      print('❌ context가 없습니다.');
    }
  }
}
