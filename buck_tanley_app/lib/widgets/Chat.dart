import 'package:flutter/material.dart';

class Chat extends StatelessWidget {
  final String message;
  final int type;
  final String time;
  const Chat({super.key, required this.message, required this.type, required this.time});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Row(
        mainAxisAlignment: type == 1 ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (type == 1) Text(time),
          if (type == 1) SizedBox(width: 10,),
          Container(
            width: 400,
            padding: EdgeInsets.symmetric(vertical: 5, horizontal: 20),
            decoration: BoxDecoration(
              border: Border.all(),
              borderRadius: BorderRadius.circular(20),
              color: type == 1 ? Colors.amber : Colors.grey,
            ),
            child: Text(
              message,
              style: TextStyle(
                fontSize: 20,
              ),
            ),
          ),
          if (type == 2) SizedBox(width: 10,),
          if (type == 2) Text(time),
        ],
      ),
    );
  }
}
