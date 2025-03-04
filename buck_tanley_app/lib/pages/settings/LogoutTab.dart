import 'package:buck_tanley_app/core/Import.dart';
import 'package:flutter/material.dart';

class LogoutTab extends StatelessWidget {
  const LogoutTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("로그아웃")),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            getIt<UserProvider>().logout();
            Navigator.pop(context);
          },
          child: Text("로그아웃"),
        ),
      ),
    );
  }
}
