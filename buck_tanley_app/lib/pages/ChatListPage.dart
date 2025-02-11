import 'package:buck_tanley_app/models/Freind.dart';
import 'package:buck_tanley_app/widgets/Conversation.dart';
import 'package:flutter/material.dart';

class ChatListPage extends StatefulWidget {
  const ChatListPage({super.key});

  @override
  State<ChatListPage> createState() => _ChatListPageState();
}

class _ChatListPageState extends State<ChatListPage> {
  List<Freind> freinds = [
    Freind(image: "", name: "김민수", last: "ㅎㅇ", time: "2025-09-20"),
    Freind(image: "", name: "이영희", last: "뭐", time: "2025-02-01"),
    Freind(image: "", name: "박철수", last: "어쩔", time: "2024-12-23"),
    Freind(image: "", name: "김이박", last: "뭐함", time: "2024-05-23"),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Container(
        color: Colors.red,
        height: 50,
      ),
      for (var i = 0; i < freinds.length; i++)
        Conversation(freind: freinds[i],)
    ]);
  }
}