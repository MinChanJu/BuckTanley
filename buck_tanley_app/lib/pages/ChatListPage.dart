import 'package:buck_tanley_app/models/Chat.dart';
// import 'package:buck_tanley_app/pages/ChattingPage.dart';
import 'package:buck_tanley_app/widgets/ChatWidget.dart';
import 'package:flutter/material.dart';

class ChatListPage extends StatefulWidget {
  const ChatListPage({super.key});

  @override
  State<ChatListPage> createState() => _ChatListPageState();
}

class _ChatListPageState extends State<ChatListPage> {
  List<Chat> chats = [
    Chat(image: "", name: "김민수", userId: "abc", time: "2025-09-20"),
    Chat(image: "", name: "이영희", userId: "def", time: "2025-02-01"),
    Chat(image: "", name: "박철수", userId: "desf", time: "2024-12-23"),
    Chat(image: "", name: "김이박", userId: "aa", time: "2024-05-23"),
    Chat(image: "", name: "김순자", userId: "skk", time: "2024-05-23"),
    Chat(image: "", name: "박친수", userId: "sfsdg", time: "2024-05-23"),
    Chat(image: "", name: "닉네임", userId: "sd", time: "2024-05-23"),
    Chat(image: "", name: "비스코", userId: "bf", time: "2024-05-23"),
    Chat(image: "", name: "아주대", userId: "sdv", time: "2024-05-23"),
    Chat(image: "", name: "가위", userId: "be", time: "2024-05-23"),
    Chat(image: "", name: "보배", userId: "erb", time: "2024-05-23"),
    Chat(image: "", name: "커피짱", userId: "ertb", time: "2024-05-23"),
    Chat(image: "", name: "마우스 아무거나", userId: "tyrr", time: "2024-05-23"),
    Chat(image: "", name: "벅텐리가 뭐야", userId: "ji", time: "2024-05-23"),
    Chat(image: "", name: "거치대", userId: "nb", time: "2024-05-23"),
    Chat(image: "", name: "모니터", userId: "qlem", time: "2024-05-23"),
    Chat(image: "", name: "맥북", userId: "sdpv", time: "2024-05-23"),
    Chat(image: "", name: "텀블러", userId: "blrtnrj", time: "2024-05-23"),
    Chat(image: "", name: "물티슈", userId: "flu", time: "2024-05-23"),
    Chat(image: "", name: "달력", userId: "lef", time: "2024-05-23"),
    Chat(image: "", name: "담요", userId: "de", time: "2024-05-23"),
    Chat(image: "", name: "아무거나 해", userId: "bg", time: "2024-05-23"),
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
            decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Colors.grey, width: 1))),
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
