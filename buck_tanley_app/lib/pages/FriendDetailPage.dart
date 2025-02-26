import 'package:buck_tanley_app/SetUp.dart';
import 'package:buck_tanley_app/widgets/ImageWidget.dart';
import 'package:flutter/material.dart';

class FriendDetailPage extends StatelessWidget {
  final UserDTO friend;
  final ImageProvider friendImage;
  const FriendDetailPage({super.key, required this.friend, required this.friendImage});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(friend.nickname),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: MediaQuery.of(context).size.width * 0.7,
              height: MediaQuery.of(context).size.height * 0.6,
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 209, 209, 209),
                image: DecorationImage(
                  image: friendImage,
                  fit: BoxFit.contain,
                ),
              ),
              child: GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) => ImageWidget(imageProvider: friendImage),
                  );
                },
              ),
            ),
            Text(
              friend.nickname,
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.w700,
              ),
            ),
            Text(
              friend.introduction,
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
                  DataCell(Text(friend.userId)),
                  DataCell(Text(friend.age.toString())),
                  DataCell(Text(friend.gender ? "남" : "여")),
                ]),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
