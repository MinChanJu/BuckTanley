import 'package:flutter/material.dart';

class Registerpage extends StatelessWidget {
  const Registerpage({super.key});

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


      ),
      // 광고 영역  - 배너 클릭시 링크 연결되게 수정해야 하니 버튼으로 변경해야함
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
