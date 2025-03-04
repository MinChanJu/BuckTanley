import 'package:buck_tanley_app/core/Import.dart';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';

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
    final LoginDTO loginDTO = LoginDTO(
      userId: _idController.text,
      userPw: _pwController.text,
      platform: Server.platform,
      fcmToken: FirebaseSettings.fcmToken,
    );

    if (loginDTO.userId == "" || loginDTO.userPw == "") {
      Show.snackbar("빈칸을 채워넣으세요");
      return;
    }

    getIt<UserProvider>().login(loginDTO);
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
                      onSubmitted: (_) => _loginUser(),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: _pwController,
                      decoration: InputDecoration(labelText: 'PassWord'),
                      obscureText: true,
                      onSubmitted: (_) => _loginUser(),
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
                        MaterialPageRoute(builder: (context) => const RegisterPage()),
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
