import 'package:buck_tanley_app/SetUp.dart';
import 'package:flutter/material.dart';

class ChatListPage extends StatefulWidget {
  const ChatListPage({super.key});

  @override
  State<ChatListPage> createState() => _ChatListPageState();
}

class _ChatListPageState extends State<ChatListPage> {
  List<UserDTO> friends = [
    UserDTO(userId: "abc", nickname: "안토니", image: "", introduction: "안녕하세요", gender: false, age: 19, status: 0),
    UserDTO(userId: "def", nickname: "다니엘", image: "", introduction: "조용히 해", gender: true, age: 20, status: 1),
    UserDTO(userId: "test", nickname: "테스트", image: "", introduction: "테스트 계정", gender: true, age: 23, status: 2),
    UserDTO(userId: "ab", nickname: "기본", image: "", introduction: "ㄴ우힌웊", gender: false, age: 32, status: 3),
    UserDTO(userId: "sdbe", nickname: "조용", image: "", introduction: "ㄴㅇㅁㅍㄴㅇㅁㅍ휴", gender: true, age: 21, status: 0),
    UserDTO(userId: "wfew", nickname: "심심", image: "", introduction: "ㄴ윰ㄴㅇ", gender: true, age: 54, status: 1),
    UserDTO(userId: "te", nickname: "가위", image: "", introduction: "ㅋㅌㅍㅇ류", gender: false, age: 25, status: 1),
    UserDTO(userId: "rnt", nickname: "커피", image: "", introduction: "ㅇ륭륜ㅁㅇㅍ", gender: false, age: 18, status: 2),
    UserDTO(userId: "khmk", nickname: "러아", image: "", introduction: "ㄴㅇㅍㄴㅁ ㄹ", gender: true, age: 27, status: 0),
    UserDTO(userId: "xnj", nickname: "아러후", image: "", introduction: " ㄹㅇ ㅎㄹ", gender: false, age: 24, status: 3),
    UserDTO(userId: "fob", nickname: "무래하", image: "", introduction: "ㄹㅎ ㅇㄹ ㅇㄴㄴㅇ", gender: true, age: 22, status: 3),
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
            itemCount: friends.length,
            itemBuilder: (context, index) {
              return ChatWidget(friend: friends[index]);
            },
          ),
        ),
      ],
    );
  }
}
