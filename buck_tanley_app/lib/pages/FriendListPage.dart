import 'package:buck_tanley_app/SetUp.dart';
import 'package:buck_tanley_app/utils/Test.dart';
import 'package:flutter/material.dart';

class FriendListPage extends StatefulWidget {
  const FriendListPage({super.key});

  @override
  State<FriendListPage> createState() => _FriendListPageState();
}

class _FriendListPageState extends State<FriendListPage> {
  List<UserDTO> friends = [
    UserDTO(userId: "test00", nickname: "이미지 테스트", image: Test.testoo, introduction: "이미지 소개중..", gender: true, age: 30, status: 0),
    UserDTO(userId: "test11", nickname: "테스트11", image: Test.testll, introduction: "테스트 계정", gender: false, age: 25, status: 0),
    UserDTO(userId: "test", nickname: "나임", image: "", introduction: "계정", gender: true, age: 23, status: 2),
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
  void initState() {
    super.initState();
    friends.sort((a, b) => a.nickname.compareTo(b.nickname));
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    User? user = getIt<UserProvider>().user;
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
                backgroundImage: getIt<UserProvider>().userImage,
                backgroundColor: Colors.grey[400],
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
              Expanded(child: Text(user?.introduction ?? "")),
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
