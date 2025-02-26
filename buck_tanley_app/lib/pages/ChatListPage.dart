import 'package:buck_tanley_app/SetUp.dart';
import 'package:buck_tanley_app/utils/Test.dart';
import 'package:flutter/material.dart';

class ChatListPage extends StatefulWidget {
  const ChatListPage({super.key});

  @override
  State<ChatListPage> createState() => _ChatListPageState();
}

class _ChatListPageState extends State<ChatListPage> {
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
    sortFriends();
    getIt<MessageProvider>().addListener(sortFriends);
  }

  @override
  void dispose() {
    // 메모리 누수를 방지하기 위해 리스너 제거
    getIt<MessageProvider>().removeListener(sortFriends);
    super.dispose();
  }

  void sortFriends() {
    String userId = getIt<UserProvider>().userId;
    MessageProvider messageProvider = getIt<MessageProvider>();

    setState(() {
      friends.sort((a, b) {
        String roomIdA = Room.getRoomId(userId, a.userId);
        String roomIdB = Room.getRoomId(userId, b.userId);

        Message? lastA = messageProvider.getlastForRoom(roomIdA);
        Message? lastB = messageProvider.getlastForRoom(roomIdB);

        if (lastA == null && lastB == null) return a.nickname.compareTo(b.nickname);
        if (lastA == null) return 1;
        if (lastB == null) return -1;

        switch (Time.compareTime(lastA.createdAt, lastB.createdAt)) {
          case 0:
            return a.nickname.compareTo(b.nickname);
          case 1:
          case 2:
            return 1;
          case 3:
          case 4:
            return -1;
          default:
            return 0;
        }
      });
    });
  }

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
