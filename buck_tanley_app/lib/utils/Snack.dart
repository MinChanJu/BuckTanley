import 'package:buck_tanley_app/SetUp.dart';
import 'package:flutter/material.dart';

class Snack {
  // 스낵바 표시 메서드
  static void showSnackbar(String message) {
    final context = getIt<GlobalKey<NavigatorState>>().currentContext;
    if (context != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    } else {
      print('❌ Snackbar를 표시할 수 없습니다. context가 없습니다.');
    }
  }
}