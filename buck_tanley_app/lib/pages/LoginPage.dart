import 'package:buck_tanley_app/pages/RegisterPage.dart';
import 'package:buck_tanley_app/provider/UserProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart' as app_provider;
import 'package:flutter/gestures.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: SizedBox(
          height: 50,
          child: Image.asset('assets/images/BuckTanleyLogo.png',
              fit: BoxFit.contain),
        ),
      ),
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
                    const TextField(
                      decoration: InputDecoration(labelText: 'ID'),
                    ),
                    const SizedBox(height: 10),
                    const TextField(
                      decoration: InputDecoration(labelText: 'PassWord'),
                      obscureText: true,
                    ),
                    const SizedBox(height: 20),
                    Align(
                      alignment: Alignment.centerRight,
                      child: ElevatedButton(
                        onPressed: () {
                          app_provider.Provider.of<UserProvider>(context,
                                  listen: false)
                              .login("sgndsflonlas");
                        },
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
      bottomNavigationBar: Container(
        color: Colors.grey[300],
        height: 100,
        width: double.infinity,
        alignment: Alignment.center,
        child: const Text('광고'),
      ),
    );
  }
}
