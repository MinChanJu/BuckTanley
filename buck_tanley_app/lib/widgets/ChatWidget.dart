import 'package:buck_tanley_app/SetUp.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChatWidget extends StatelessWidget {
  final UserDTO friend;
  const ChatWidget({super.key, required this.friend});

  @override
  Widget build(BuildContext context) {
    ImageProvider friendImage = ImageConverter.getImageDecode(friend.image);
    final messageProvider = context.watch<MessageProvider>();
    final roomId = Room.getRoomId(getIt<UserProvider>().userId, friend.userId);
    Message? last = messageProvider.getLastForRoom(roomId);
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
          Navigate.pushChatting(friend, friendImage, false);
        },
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            CircleAvatar(
              radius: 25,
              backgroundImage: friendImage,
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
