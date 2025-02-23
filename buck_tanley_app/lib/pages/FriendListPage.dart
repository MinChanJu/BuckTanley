import 'package:buck_tanley_app/SetUp.dart';
import 'package:provider/provider.dart' as app_provider;
import 'package:flutter/material.dart';

import 'package:flutter/foundation.dart' as foundation;

class FriendListPage extends StatefulWidget {
  const FriendListPage({super.key});

  @override
  State<FriendListPage> createState() => _FriendListPageState();
}

class _FriendListPageState extends State<FriendListPage> {
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
    User? user = app_provider.Provider.of<UserProvider>(context, listen: false).user;
    Imager? imager = app_provider.Provider.of<UserProvider>(context, listen: false).imager;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            width: screenWidth,
            decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Colors.grey, width: 1))),
            child: Text("친구 목록", style: TextStyle(fontSize: 25)),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            children: [
              CircleAvatar(
                radius: 40,
                backgroundColor: Colors.grey[400],
                backgroundImage: imager == null
                    ? AssetImage("assets/images/BuckTanleyLogo.png")
                    : (foundation.kIsWeb
                        ? (imager.webImage == null ? AssetImage("assets/images/BuckTanleyLogo.png") : MemoryImage(imager.webImage!)) // 웹
                        : (imager.mobileImage == null ? AssetImage("assets/images/BuckTanleyLogo.png") : FileImage(imager.mobileImage!))), // 모바일
              ),
              SizedBox(width: 20),
              Text(
                user?.nickname ?? "없음",
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(width: 20),
              Expanded(child: Text(user?.introduction ?? "안녕하세요 벅텐리입니다.")),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: friends.length,
            itemBuilder: (context, index) {
              return FriendWidget(friend: friends[index]);
            },
          ),
        ),
      ],
    );
  }
}
