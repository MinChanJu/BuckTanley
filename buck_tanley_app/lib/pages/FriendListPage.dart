import 'package:buck_tanley_app/SetUp.dart';
import 'package:buck_tanley_app/utils/Test.dart';
import 'package:flutter/material.dart';

class FriendListPage extends StatefulWidget {
  const FriendListPage({super.key});

  @override
  State<FriendListPage> createState() => _FriendListPageState();
}

class _FriendListPageState extends State<FriendListPage> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      final user =
          app_provider.Provider.of<UserProvider>(context, listen: false).user;
      if (user != null) {
        app_provider.Provider.of<FriendProvider>(context, listen: false)
            .loadFriends(user.userId);
      }
    });
  }


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
            decoration: BoxDecoration(
                border:
                    Border(bottom: BorderSide(color: Colors.grey, width: 1))),
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
          child: app_provider.Consumer<FriendProvider>(
            builder: (context, friendProvider, child) {
              if (friendProvider.isLoading) {
                return Center(child: CircularProgressIndicator()); // 로딩 중
              }
              if (friendProvider.friends.isEmpty) {
                return Center(child: Text("친구가 없습니다.")); // 친구 없음
              }
              return ListView.builder(
                itemCount: friendProvider.friends.length,
                itemBuilder: (context, index) {
                  return FriendWidget(friend: friendProvider.friends[index]);
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
