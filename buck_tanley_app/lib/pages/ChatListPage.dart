import 'package:buck_tanley_app/core/Import.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChatListPage extends StatefulWidget {
  const ChatListPage({super.key});

  @override
  State<ChatListPage> createState() => _ChatListPageState();
}

class _ChatListPageState extends State<ChatListPage> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () async {
      final String userId = getIt<UserProvider>().userId;
      await getIt<FriendProvider>().loadFriends(userId);
    });
  }

  List<UserDTO> sortFriends(List<UserDTO> friends) {
    String userId = getIt<UserProvider>().userId;
    MessageProvider messageProvider = getIt<MessageProvider>();

    friends.sort((a, b) {
      String roomIdA = Room.getRoomId(userId, a.userId);
      String roomIdB = Room.getRoomId(userId, b.userId);

      Message? lastA = messageProvider.getLastForRoom(roomIdA);
      Message? lastB = messageProvider.getLastForRoom(roomIdB);

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
    return friends;
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
          child: Consumer2<FriendProvider, MessageProvider>(
            builder: (context, friendProvider, messageProvider, child) {
              if (friendProvider.isLoading) {
                return Center(child: CircularProgressIndicator()); // 로딩 중
              }
              List<UserDTO> friends = friendProvider.friends.toList();
              if (friends.isEmpty) {
                return Center(child: Text("이야기할 친구가 없습니다.")); // 친구 없음
              }
              friends = sortFriends(friends);
              return ListView.builder(
                itemCount: friends.length,
                itemBuilder: (context, index) {
                  return ChatWidget(friend: friends[index]);
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
