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
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    User? user =
        app_provider.Provider.of<UserProvider>(context, listen: false).user;
    Imager? imager =
        app_provider.Provider.of<UserProvider>(context, listen: false).imager;
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
                backgroundColor: Colors.grey[400],
                backgroundImage: imager == null
                    ? AssetImage("assets/images/BuckTanleyLogo.png")
                    : (foundation.kIsWeb
                        ? (imager.webImage == null
                            ? AssetImage("assets/images/BuckTanleyLogo.png")
                            : MemoryImage(imager.webImage!)) // 웹
                        : (imager.mobileImage == null
                            ? AssetImage("assets/images/BuckTanleyLogo.png")
                            : FileImage(imager.mobileImage!))), // 모바일
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
