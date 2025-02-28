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

  static void pushChatting(UserDTO partner, ImageProvider partnerImage, bool random) {
    final context = getIt<GlobalKey<NavigatorState>>().currentContext;
    if (context != null) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ChattingPage(partner: partner, partnerImage: partnerImage, random: random)),
      );
    } else {
      print('❌ context가 없습니다.');
    }
  }

  static void pushFriendDetail(UserDTO friend, ImageProvider friendImage) {
    final context = getIt<GlobalKey<NavigatorState>>().currentContext;
    if (context != null) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => FriendDetailPage(friend: friend, friendImage: friendImage)),
      );
    } else {
      print('❌ context가 없습니다.');
    }
  }
}
