import 'package:buck_tanley_app/models/Chat.dart';
import 'package:buck_tanley_app/pages/ChattingPage.dart';
import 'package:buck_tanley_app/provider/MessageProvider.dart';
import 'package:buck_tanley_app/utils/Room.dart';
import 'package:flutter/material.dart';
import 'package:buck_tanley_app/provider/UserProvider.dart';
import 'package:provider/provider.dart' as app_provider;

class ChatWidget extends StatelessWidget {
  final Chat chat;
  const ChatWidget({super.key, required this.chat});

  @override
  Widget build(BuildContext context) {
    String? token = app_provider.Provider.of<UserProvider>(context, listen: false).token;
    String roomId = Room.getRoomId(token ?? "", chat.userId);
    String last = app_provider.Provider.of<MessageProvider>(context, listen: true).getlastForRoom(roomId);
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
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ChattingPage(sender: token ?? "", receiver: chat.userId, random: false)),
          );
        },
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            CircleAvatar(
              radius: 25,
              backgroundImage: AssetImage(chat.image == "" ? "assets/images/dinosaur1.png" : chat.image),
              backgroundColor: Color.fromARGB(255, 209, 209, 209),
            ),
            SizedBox(
              width: 20,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    chat.name,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                  Text(
                    last,
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
            Text(chat.time),
          ],
        ),
      ),
    );
  }
}
