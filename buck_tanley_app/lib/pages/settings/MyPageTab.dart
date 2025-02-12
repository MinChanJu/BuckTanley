import 'package:flutter/material.dart';

class MyPageTab extends StatelessWidget {
  const MyPageTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("마이페이지 설정")),
      body: Center(child: Text("마이페이지 설정")),
    );
  }
}