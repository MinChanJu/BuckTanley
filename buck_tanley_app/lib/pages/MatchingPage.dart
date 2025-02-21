import 'dart:convert';

import 'package:buck_tanley_app/models/MatchDTO.dart';
import 'package:buck_tanley_app/pages/ChattingPage.dart';
import 'package:buck_tanley_app/provider/UserProvider.dart';
import 'package:buck_tanley_app/services/WebSocketService.dart';
import 'package:buck_tanley_app/widgets/MiniGameWidget.dart';
import 'package:provider/provider.dart' as app_provider;
import 'package:flutter/material.dart';

class MatchingPage extends StatefulWidget {
  const MatchingPage({super.key});

  @override
  State<MatchingPage> createState() => _MatchingPageState();
}

class _MatchingPageState extends State<MatchingPage> {
  bool isLoading = false;
  bool showMiniGame = false;
  bool match = false;
  bool accept = false;
  String partner = "";
  late AssetImage _mySelf, _opponent;
  late WebSocketService matchWS;
  late MatchDTO matchDTO;

  @override
  void initState() {
    super.initState();
    _mySelf = AssetImage('assets/images/BuckTanleyLogo.png');
    _opponent = AssetImage('assets/images/dinosaur1.png');
  }

  void matching(String? userId) {
    if (mounted && userId != null) {
      setState(() {
        isLoading = true;
        showMiniGame = false;
      });

      matchWS = WebSocketService.getInstance(userId, "match");
      matchWS.messages.listen((data) {
        try {
          matchDTO = MatchDTO.fromJson(jsonDecode(data));
          if (matchDTO.status) {
            if (mounted) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ChattingPage(sender: matchDTO.userId1, receiver: matchDTO.userId2, random: true)),
                );
              });
            }
            setState(() {
              isLoading = false;
              showMiniGame = false;
              match = false;
              accept = false;
              partner = "";
            });
            matchWS.disconnect();
          } else if (isLoading) {
            setState(() {
              isLoading = false;
              showMiniGame = false;
              match = true;
              accept = false;
              partner = matchDTO.userId2;
            });
          } else {
            setState(() {
              match = false;
              accept = false;
              partner = "";
            });
            matchWS.disconnect();
          }
          print('📨 매칭 메세지 수신: ${matchDTO.toJson()}');
        } catch (e) {
          print('❌ 메시지 파싱 실패: $e');
        }
      });

      Future.delayed(Duration(seconds: 1), () {
        if (mounted) {
          setState(() {
            showMiniGame = true;
          });
        }
      });
    }
  }

  Widget before() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        backgroundColor: const Color.fromARGB(255, 163, 110, 249),
        foregroundColor: Colors.white,
        padding: EdgeInsets.symmetric(
          vertical: 15,
          horizontal: 30,
        ),
      ),
      onPressed: () {
        matching(app_provider.Provider.of<UserProvider>(context, listen: false).token);
      },
      child: Text('매칭', style: TextStyle(fontSize: 20)),
    );
  }

  Widget during() {
    return Column(
      children: [
        Text('매칭 중...', style: TextStyle(fontSize: 20)),
        AnimatedOpacity(
          opacity: showMiniGame ? 1.0 : 0.0, // 서서히 나타나기
          duration: const Duration(seconds: 1), // 애니메이션 지속 시간
          curve: Curves.easeInOut, // 부드러운 효과
          child: showMiniGame ? MiniGameWidget() : Container(),
        ),
      ],
    );
  }

  Widget after() {
    return Column(
      children: [
        Text(partner, style: TextStyle(fontSize: 30)),
        SizedBox(height: 20),
        if (!accept)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: EdgeInsets.all(0),
                  backgroundColor: Colors.green,
                ),
                onPressed: () {
                  MatchDTO sendMatch = MatchDTO(status: true, userId1: matchDTO.userId1, userId2: matchDTO.userId2);
                  matchWS.sendMessage(sendMatch.toJson());
                  setState(() {
                    accept = true;
                  });
                },
                child: Icon(Icons.check),
              ),
              SizedBox(width: 50),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: EdgeInsets.all(0),
                  backgroundColor: Colors.red,
                ),
                onPressed: () {
                  if (mounted) {
                    MatchDTO sendMatch = MatchDTO(status: false, userId1: matchDTO.userId1, userId2: matchDTO.userId2);
                    matchWS.sendMessage(sendMatch.toJson());
                  }
                },
                child: Icon(Icons.clear),
              ),
            ],
          ),
        if (accept)
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Colors.amber,
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
              child: Text("기다리는 중...", style: TextStyle(fontSize: 15)),
            ),
          )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

    return AnimatedPadding(
      padding: EdgeInsets.only(top: isLoading ? screenHeight / 10 : screenHeight / 4),
      duration: Duration(seconds: 1),
      curve: Curves.easeInOut,
      child: Column(
        children: [
          Stack(
            children: [
              CircleAvatar(
                radius: 90,
                backgroundColor: Color.fromARGB(255, 209, 209, 209),
              ),
              AnimatedOpacity(
                opacity: match ? 0.0 : 1.0,
                duration: const Duration(milliseconds: 500),
                curve: Curves.easeInOut,
                child: CircleAvatar(
                  radius: 90,
                  backgroundImage: _mySelf,
                  backgroundColor: Colors.transparent,
                ),
              ),
              AnimatedOpacity(
                opacity: match ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 500),
                curve: Curves.easeInOut,
                child: CircleAvatar(
                  radius: 90,
                  backgroundImage: _opponent,
                  backgroundColor: Colors.transparent,
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          if (!isLoading && !match) before(),
          if (!isLoading && match) after(),
          if (isLoading) during(),
        ],
      ),
    );
  }
}
