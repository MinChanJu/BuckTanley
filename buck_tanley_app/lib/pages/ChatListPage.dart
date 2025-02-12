import 'package:buck_tanley_app/models/Chat.dart';
import 'package:buck_tanley_app/widgets/ChatWidget.dart';
import 'package:flutter/material.dart';

class ChatListPage extends StatefulWidget {
  const ChatListPage({super.key});

  @override
  State<ChatListPage> createState() => _ChatListPageState();
}

class _ChatListPageState extends State<ChatListPage> {
  List<Chat> chats = [
    Chat(image: "", name: "김민수", last: "ㅎㅇ니ㅜ히ㅓㅜㄴ이무힌웋ㄴ웋ㅇ니ㅜㅎ날훙니ㅜ힘웋넝훈밍후누힌우히ㅓ눙히후", time: "2025-09-20"),
    Chat(image: "", name: "이영희", last: "뭐", time: "2025-02-01"),
    Chat(image: "", name: "박철수", last: "어쩔", time: "2024-12-23"),
    Chat(image: "", name: "김이박", last: "뭐함", time: "2024-05-23"),
    Chat(image: "", name: "김순자", last: "조용", time: "2024-05-23"),
    Chat(image: "", name: "박친수", last: "닥쳐", time: "2024-05-23"),
    Chat(image: "", name: "닉네임", last: "벅텐리", time: "2024-05-23"),
    Chat(image: "", name: "비스코", last: "아라라라", time: "2024-05-23"),
    Chat(image: "", name: "아주대", last: "쉿", time: "2024-05-23"),
    Chat(image: "", name: "가위", last: "굿", time: "2024-05-23"),
    Chat(image: "", name: "보배", last: "나이스", time: "2024-05-23"),
    Chat(image: "", name: "커피짱", last: "심심해", time: "2024-05-23"),
    Chat(image: "", name: "마우스 아무거나", last: "좀 조용히 좀 해봐", time: "2024-05-23"),
    Chat(image: "", name: "벅텐리가 뭐야", last: "ㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋ", time: "2024-05-23"),
    Chat(image: "", name: "거치대", last: "ㅇㅇ", time: "2024-05-23"),
    Chat(image: "", name: "모니터", last: "ㅇㄷ", time: "2024-05-23"),
    Chat(image: "", name: "맥북", last: "프로젝트", time: "2024-05-23"),
    Chat(image: "", name: "텀블러", last: "미니게임할까", time: "2024-05-23"),
    Chat(image: "", name: "물티슈", last: "플루터", time: "2024-05-23"),
    Chat(image: "", name: "달력", last: "레전드", time: "2024-05-23"),
    Chat(image: "", name: "담요", last: "다트", time: "2024-05-23"),
    Chat(image: "", name: "아무거나 해", last: "구글짱", time: "2024-05-23"),
  ];

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            width: screenWidth,
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: Colors.grey, width: 1))
            ),
            child: Text("채팅", style: TextStyle(fontSize: 25)),
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: chats.length,
            itemBuilder: (context, index) {
              return ChatWidget(chat: chats[index]);
            },
          ),
        ),
      ],
    );
  }
}
