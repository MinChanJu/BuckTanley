import 'package:buck_tanley_app/models/Message.dart';
import 'package:buck_tanley_app/widgets/MessageWidget.dart';
import 'package:flutter/material.dart';

class ChattingPage extends StatefulWidget {
  const ChattingPage({super.key});

  @override
  State<ChattingPage> createState() => _ChattingPageState();
}

class _ChattingPageState extends State<ChattingPage> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _textController = TextEditingController();
  late AssetImage _opponent;

  @override
  void initState() {
    super.initState();
    _opponent = AssetImage('assets/images/dinosaur1.png');
    // 처음 화면이 열릴 때 맨 아래로 이동
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _textController.dispose();
    super.dispose();
  }

  List<Message> messages = [
    Message(message: "message", type: 1, time: "time"),
    Message(message: "message", type: 2, time: "time"),
    Message(message: "message", type: 1, time: "time"),
    Message(message: "message", type: 2, time: "time"),
    Message(message: "message", type: 2, time: "time"),
    Message(message: "message", type: 1, time: "time"),
    Message(message: "message", type: 2, time: "time"),
    Message(message: "message", type: 2, time: "time"),
    Message(message: "message", type: 2, time: "time"),
    Message(message: "message", type: 1, time: "time"),
    Message(message: "message", type: 1, time: "time"),
    Message(message: "message", type: 1, time: "time"),
    Message(message: "message", type: 1, time: "time"),
    Message(message: "message", type: 2, time: "time"),
    Message(message: "message", type: 2, time: "time"),
    Message(message: "message", type: 2, time: "time"),
    Message(message: "message", type: 2, time: "time"),
    Message(message: "message", type: 1, time: "time"),
    Message(message: "message", type: 1, time: "time"),
    Message(message: "message", type: 1, time: "time"),
    Message(message: "message", type: 2, time: "time"),
    Message(message: "message", type: 2, time: "time"),
    Message(message: "message", type: 2, time: "time"),
  ];

  void _scrollToBottom() {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: Duration(milliseconds: 100),
      curve: Curves.easeOut,
    );
  }

  void _sendMessage() {
    setState(() {
      messages.add(Message(message: _textController.text, type: 1, time: "지금"));
      _textController.text = "";
    });
    print("입력된 값: ${_textController.text}");

    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
  }

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
        child: ListView.builder(
          controller: _scrollController,
          itemCount: messages.length,
          itemBuilder: (context, index) {
            return MessageWidget(message: messages[index]);
          },
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _textController,
                decoration: InputDecoration(
                  labelText: "메시지 입력",
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            ElevatedButton(onPressed: _sendMessage, child: Icon(Icons.send))
          ],
        ),
      ),
    );
  }
}
