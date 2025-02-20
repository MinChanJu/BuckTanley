import 'package:buck_tanley_app/models/entity/Message.dart';
import 'package:buck_tanley_app/utils/Time.dart';
import 'package:flutter/material.dart';

class MessageWidget extends StatelessWidget {
  final Message message;
  final String userId;
  const MessageWidget({super.key, required this.message, required this.userId});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    String time = Time.getFormatTime(message.createdAt);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Row(
        mainAxisAlignment: message.sender == userId ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (message.sender == userId) Text(time),
          if (message.sender == userId) SizedBox(width: 10),
          Container(
            constraints: BoxConstraints(maxWidth: screenWidth * 0.7),
            padding: EdgeInsets.symmetric(vertical: 5, horizontal: 20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: message.sender == userId ? Colors.amber : Colors.grey,
            ),
            child: Text(
              message.content,
              style: TextStyle(
                fontSize: 20,
              ),
            ),
          ),
          if (message.sender != userId) SizedBox(width: 10),
          if (message.sender != userId) Text(time),
        ],
      ),
    );
  }
}
