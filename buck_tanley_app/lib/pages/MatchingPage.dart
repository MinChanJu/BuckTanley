import 'package:buck_tanley_app/widgets/MiniGame.dart';
import 'package:flutter/material.dart';

class MatchingPage extends StatefulWidget {
  const MatchingPage({super.key});

  @override
  State<MatchingPage> createState() => _MatchingPageState();
}

class _MatchingPageState extends State<MatchingPage> {
  int data = 0;
  bool isLoading = false;
  bool showMiniGame = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            AnimatedPadding(
              padding: EdgeInsets.only(top: isLoading ? 100 : 200),
              duration: Duration(seconds: 1),
              curve: Curves.easeInOut,
              child: CircleAvatar(
                radius: 75,
                backgroundImage: const AssetImage('assets/images/BuckTanleyLogo.png'),
                backgroundColor: Colors.blue,
              ),
            ),
            SizedBox(height: 20),
            if (!isLoading)
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    isLoading = !isLoading;
                  });

                  Future.delayed(Duration(seconds: 1), () {
                    setState(() {
                      showMiniGame = true;
                    });
                  });

                  Future.delayed(Duration(seconds: 100), () {
                    setState(() {
                      isLoading = false;
                      showMiniGame = false;
                    });
                  });
                },
                child: Text('이동하기'),
              ),
            if (isLoading) Text('매칭 중...'),
            AnimatedOpacity(
              opacity: showMiniGame ? 1.0 : 0.0, // 서서히 나타나기
              duration: const Duration(milliseconds: 1000), // 애니메이션 지속 시간
              curve: Curves.easeInOut, // 부드러운 효과
              child: showMiniGame ? MiniGame() : Container(),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          children: [
            Expanded(
              child: Container(
                color: Colors.red,
              ),
            ),
            Expanded(
              child: Container(
                color: Colors.blue,
              ),
            ),
            Expanded(
              child: Container(
                color: Colors.purple,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

