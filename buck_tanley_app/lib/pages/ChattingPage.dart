import 'package:buck_tanley_app/models/Message.dart';
import 'package:buck_tanley_app/widgets/Chat.dart';
import 'package:flutter/material.dart';

class ChattingPage extends StatefulWidget {
  const ChattingPage({super.key});

  @override
  State<ChattingPage> createState() => _ChattingPageState();
}

class _ChattingPageState extends State<ChattingPage> {
  final TextEditingController _controller = TextEditingController();
  late AssetImage _opponent;

  @override
  void initState() {
    super.initState();
    _opponent = AssetImage('assets/images/dinosaur1.png');
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  List<Message> messages = [
    Message(message: "message", type: 1, time: "time"),
    Message(message: "message", type: 2, time: "time"),
    Message(message: "message", type: 1, time: "time"),
    Message(message: "message", type: 2, time: "time"),
    Message(message: "message", type: 2, time: "time"),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: CircleAvatar(
          radius: 20,
          backgroundImage: _opponent,
          backgroundColor: Color.fromARGB(255, 209, 209, 209),
        ),
      ),
      body: Container(
        color: Colors.red,
        child: Column(
          children: [
            for (var i = 0; i < messages.length; i++)
              Chat(message: messages[i])
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _controller,
                decoration: InputDecoration(
                  labelText: "메시지 입력",
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  messages.add(Message(message: _controller.text, type: 1, time: "지금"));
                  _controller.text = "";
                });
                print("입력된 값: ${_controller.text}");
              },
              child: Text("입력값 확인"),
            )
          ],
        ),
      ),
    );
  }
}
