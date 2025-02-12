import 'package:flutter/material.dart';

class AppInfoTab extends StatelessWidget {
  const AppInfoTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("앱 정보")),
      body: Center(child: Text("앱 정보")),
    );
  }
}