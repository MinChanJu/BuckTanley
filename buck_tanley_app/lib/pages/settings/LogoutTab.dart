import 'package:buck_tanley_app/pages/LoginPage.dart';
import 'package:buck_tanley_app/provider/MessageProvider.dart';
import 'package:flutter/material.dart';
import 'package:buck_tanley_app/provider/UserProvider.dart';
import 'package:provider/provider.dart' as app_provider;

class LogoutTab extends StatelessWidget {
  const LogoutTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("로그아웃")),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            app_provider.Provider.of<UserProvider>(context, listen: false).logout();
            app_provider.Provider.of<MessageProvider>(context, listen: false).clearAllMessages();

            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => LoginPage()),
            );
          },
          child: Text("로그아웃"),
        ),
      ),
    );
  }
}
