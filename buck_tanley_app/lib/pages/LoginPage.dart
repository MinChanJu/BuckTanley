import 'dart:convert';

import 'package:buck_tanley_app/pages/PageRouter.dart';
import 'package:buck_tanley_app/pages/RegisterPage.dart';
import 'package:buck_tanley_app/provider/UserProvider.dart';
import 'package:buck_tanley_app/utils/Server.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart' as app_provider;
import 'package:flutter/gestures.dart';
import 'package:http/http.dart' as http;
import 'package:buck_tanley_app/widgets/LogoAppBar.dart';
import 'package:buck_tanley_app/widgets/AdBanner.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _pwController = TextEditingController();

  @override
  void dispose() {
    _idController.dispose();
    _pwController.dispose();
    super.dispose();
  }

  Future<void> _loginUser() async {
    final url = Uri.parse('${Server.url}/users/login');
    final headers = Server.header;
    final body = jsonEncode({
      "userId": _idController.text,
      "userPw": _pwController.text,
    });

    try {
      final response = await http.post(url, headers: headers, body: body);
      final responseData = jsonDecode(response.body);

      if (!mounted) return;

      if (response.statusCode == 200) {
        print("로그인 성공: $responseData");

        // final token = responseData['token'];
        final userId = _idController.text;

        app_provider.Provider.of<UserProvider>(context, listen: false)
            .login(userId);

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => PageRouter()),
        );
      } else {
        print("로그인 실패: $responseData");
      }
    } catch (e) {
      print("로그인 중 오류 발생: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const LogoAppBar(),
      body: Column(
        children: [
          const Spacer(),
          Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                padding: const EdgeInsets.all(16),
                width: 300,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 5,
                      spreadRadius: 2,
                      offset: Offset(2, 2),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: _idController,
                      decoration: const InputDecoration(labelText: 'ID'),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: _pwController,
                      decoration: InputDecoration(labelText: 'PassWord'),
                      obscureText: true,
                    ),
                    const SizedBox(height: 20),
                    Align(
                      alignment: Alignment.centerRight,
                      child: ElevatedButton(
                        onPressed: _loginUser,
                        child: const Text('로그인'),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
          Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: 'ID 찾기',
                  style: const TextStyle(color: Colors.blue),
                  /*recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const FindIdPage()),
                      );
                    }, */
                ),
                const TextSpan(text: '  |  '),
                TextSpan(
                  text: 'PW 찾기',
                  style: const TextStyle(color: Colors.blue),
                  /*recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const FindPwPage()),
                      );
                    },*/
                ),
                const TextSpan(text: '  |  '),
                TextSpan(
                  text: '회원가입',
                  style: const TextStyle(color: Colors.blue),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const RegisterPage()),
                      );
                    },
                ),
              ],
            ),
          ),
          const Spacer(),
        ],
      ),
      bottomNavigationBar: const AdBanner(),
    );
  }
}
