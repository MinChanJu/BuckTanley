import 'package:buck_tanley_app/SetUp.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' as foundation;
import 'package:provider/provider.dart' as app_provider;

class ChatWidget extends StatelessWidget {
  final UserDTO friend;
  const ChatWidget({super.key, required this.friend});

  @override
  Widget build(BuildContext context) {
    User? user = app_provider.Provider.of<UserProvider>(context, listen: false).user;
    String roomId = Room.getRoomId(user?.userId ?? "", friend.userId);
    Message? last = app_provider.Provider.of<MessageProvider>(context, listen: true).getlastForRoom(roomId);
    Imager? imager = ImageConverter.decodeImage(friend.image);
    return Padding(
      padding: const EdgeInsets.only(top: 10.0, left: 10.0, right: 10.0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          minimumSize: Size(double.infinity, 50),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          backgroundColor: Colors.white,
        ),
        onPressed: () {
          Navigate.pushChatting(friend, false);
        },
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            CircleAvatar(
              radius: 25,
              backgroundImage: imager == null
                  ? AssetImage("assets/images/BuckTanleyLogo.png")
                  : (foundation.kIsWeb
                      ? (imager.webImage == null ? AssetImage("assets/images/BuckTanleyLogo.png") : MemoryImage(imager.webImage!)) // 웹
                      : (imager.mobileImage == null ? AssetImage("assets/images/BuckTanleyLogo.png") : FileImage(imager.mobileImage!))), // 모바일,

              //  AssetImage(friend.image ?? "assets/images/dinosaur1.png"),
              backgroundColor: Color.fromARGB(255, 209, 209, 209),
            ),
            SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    friend.nickname,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                  Text(
                    last?.content ?? "",
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w400,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ],
              ),
            ),
            Text(last == null ? "" : Time.getFormatDate(last.createdAt)),
          ],
        ),
      ),
    );
  }
}
