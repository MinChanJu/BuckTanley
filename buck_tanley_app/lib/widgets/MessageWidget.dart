import 'package:buck_tanley_app/models/Message.dart';
import 'package:flutter/material.dart';

class MessageWidget extends StatelessWidget {
  final Message message;
  const MessageWidget({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    String time = "${message.time.hour.toString().padLeft(2, '0')}:${message.time.minute.toString().padLeft(2, '0')}";

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Row(
        mainAxisAlignment: message.type == 1 ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (message.type == 1) Text(time),
          if (message.type == 1) SizedBox(width: 10,),
          Container(
            constraints: BoxConstraints(maxWidth: screenWidth*0.7),
            padding: EdgeInsets.symmetric(vertical: 5, horizontal: 20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: message.type == 1 ? Colors.amber : Colors.grey,
            ),
            child: Text(
              message.message,
              style: TextStyle(
                fontSize: 20,
              ),
            ),
          ),
          if (message.type == 2) SizedBox(width: 10,),
          if (message.type == 2) Text(time),
        ],
      ),
    );
  }
}