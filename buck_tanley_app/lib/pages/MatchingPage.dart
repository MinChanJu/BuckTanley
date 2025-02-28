import 'dart:convert';

import 'package:buck_tanley_app/SetUp.dart';
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
  UserDTO partner = UserDTO.init(null);
  ImageProvider partnerImage = ImageConverter.getImage(null);
  late WebSocketService matchWS;
  late MatchDTO matchDTO;

  void varInit() {
    setState(() {
      isLoading = false;
      showMiniGame = false;
      match = false;
      accept = false;
      partner = UserDTO.init(null);
      partnerImage = ImageConverter.getImageDecode(null);
    });
  }

  void matching() {
    if (mounted) {
      matchWS = WebSocketService.getInstance(Server.type(0));
      matchWS.messages.listen((data) {
        try {
          matchDTO = MatchDTO.fromJson(jsonDecode(data));
          print('📨 type: ${matchWS.type}, platform: ${matchWS.platform} userId: ${matchWS.userId}, 매칭 메세지 수신: ${matchDTO.status} ${matchDTO.user1.userId} ${matchDTO.user2.userId}');

          if (matchDTO.status == "매칭") {
            varInit();
            setState(() {
              match = true;
              partner = matchDTO.user2;
              partnerImage = ImageConverter.getImageDecode(partner.image);
            });
          } else {
            if (matchDTO.status == "매칭 승인") Navigate.pushChatting(partner, partnerImage, true);
            varInit();
            matchWS.disconnect();
          }
        } catch (e) {
          print('❌ type: ${matchWS.type}, platform: ${matchWS.platform} userId: ${matchWS.userId}, 메시지 파싱 실패: $e');
        }
      }, onDone: () {
        print('🔌 type: ${matchWS.type}, platform: ${matchWS.platform} userId: ${matchWS.userId}, WebSocket 연결 종료');
      }, onError: (error) {
        print('❌ type: ${matchWS.type}, platform: ${matchWS.platform} userId: ${matchWS.userId}, WebSocket 오류: $error');
      });

      setState(() {
        isLoading = true;
        showMiniGame = false;
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
        matching();
      },
      child: Text('매칭', style: TextStyle(fontSize: 20)),
    );
  }

  Widget during() {
    return Column(
      children: [
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
            backgroundColor: Colors.red.shade300,
          ),
          onPressed: () {
            MatchDTO sendMatch = MatchDTO(status: "취소", user1: UserDTO.init(getIt<UserProvider>().userId), user2: UserDTO.init(null));
            matchWS.sendMessage(sendMatch.toJson());
          },
          child: Text("매칭 취소", style: TextStyle(color: Colors.white, fontSize: 20)),
        ),
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
        Text(partner.nickname, style: TextStyle(fontSize: 30)),
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
                  MatchDTO sendMatch = MatchDTO(status: "수락", user1: UserDTO.init(getIt<UserProvider>().userId), user2: UserDTO.init(partner.userId));
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
                    MatchDTO sendMatch = MatchDTO(status: "거절", user1: UserDTO.init(getIt<UserProvider>().userId), user2: UserDTO.init(partner.userId));
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
                  backgroundImage: getIt<UserProvider>().userImage,
                  backgroundColor: Colors.transparent,
                ),
              ),
              AnimatedOpacity(
                opacity: match ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 500),
                curve: Curves.easeInOut,
                child: CircleAvatar(
                  radius: 90,
                  backgroundImage: partnerImage,
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
