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
    Chat(image: "", name: "김민수", last: "ㅎㅇ", time: "2025-09-20"),
    Chat(image: "", name: "이영희", last: "뭐", time: "2025-02-01"),
    Chat(image: "", name: "박철수", last: "어쩔", time: "2024-12-23"),
    Chat(image: "", name: "김이박", last: "뭐함", time: "2024-05-23"),
    Chat(image: "", name: "김이박", last: "뭐함", time: "2024-05-23"),
    Chat(image: "", name: "김이박", last: "뭐함", time: "2024-05-23"),
    Chat(image: "", name: "김이박", last: "뭐함", time: "2024-05-23"),
    Chat(image: "", name: "김이박", last: "뭐함", time: "2024-05-23"),
    Chat(image: "", name: "김이박", last: "뭐함", time: "2024-05-23"),
    Chat(image: "", name: "김이박", last: "뭐함", time: "2024-05-23"),
    Chat(image: "", name: "김이박", last: "뭐함", time: "2024-05-23"),
    Chat(image: "", name: "김이박", last: "뭐함", time: "2024-05-23"),
    Chat(image: "", name: "김이박", last: "뭐함", time: "2024-05-23"),
    Chat(image: "", name: "김이박", last: "뭐함", time: "2024-05-23"),
    Chat(image: "", name: "김이박", last: "뭐함", time: "2024-05-23"),
    Chat(image: "", name: "김이박", last: "뭐함", time: "2024-05-23"),
    Chat(image: "", name: "김이박", last: "뭐함", time: "2024-05-23"),
    Chat(image: "", name: "김이박", last: "뭐함", time: "2024-05-23"),
    Chat(image: "", name: "김이박", last: "뭐함", time: "2024-05-23"),
    Chat(image: "", name: "김이박", last: "뭐함", time: "2024-05-23"),
    Chat(image: "", name: "김이박", last: "뭐함", time: "2024-05-23"),
    Chat(image: "", name: "김이박", last: "뭐함", time: "2024-05-23"),
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: chats.length,
      itemBuilder: (context, index) {
        return ChatWidget(chat: chats[index]);
      },
    );
  }
}
