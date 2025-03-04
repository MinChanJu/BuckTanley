import 'package:buck_tanley_app/core/Import.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FriendDetailPage extends StatelessWidget {
  final UserInfo friend;
  final bool random;
  const FriendDetailPage({super.key, required this.friend, required this.random});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(friend.user.nickname),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: MediaQuery.of(context).size.width * 0.7,
              height: MediaQuery.of(context).size.height * 0.6,
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 57, 57, 57),
                image: DecorationImage(
                  image: friend.image,
                  fit: BoxFit.contain,
                ),
              ),
              child: GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () => Show.dialog(context: context, builder: ImageWidget(imageProvider: friend.image)),
              ),
            ),
            Text(
              friend.user.nickname,
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.w700,
              ),
            ),
            Text(
              friend.user.introduction,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w400,
              ),
            ),
            DataTable(
              columns: [
                DataColumn(label: Text('아이디')),
                DataColumn(label: Text('나이')),
                DataColumn(label: Text('성별')),
              ],
              rows: [
                DataRow(cells: [
                  DataCell(Text(friend.user.userId)),
                  DataCell(Text(friend.user.age.toString())),
                  DataCell(Text(friend.user.gender ? "남" : "여")),
                ]),
              ],
            ),
            if (!random)
              IconButton(
                onPressed: () => Navigate.pushChatting(friend, random),
                icon: Icon(CupertinoIcons.conversation_bubble),
              ),
          ],
        ),
      ),
    );
  }
}
