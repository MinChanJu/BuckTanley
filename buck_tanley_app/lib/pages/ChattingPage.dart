import 'dart:convert';

import 'package:buck_tanley_app/SetUp.dart';
import 'package:provider/provider.dart' as app_provider;
import 'package:flutter/material.dart';

class ChattingPage extends StatefulWidget {
  final String sender;
  final String receiver;
  final bool random;
  const ChattingPage({super.key, required this.sender, required this.receiver, required this.random});

  @override
  State<ChattingPage> createState() => _ChattingPageState();
}

class _ChattingPageState extends State<ChattingPage> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _textController = TextEditingController();
  final List<Message> messages = [];
  late WebSocketService wsService;
  late AssetImage _opponent;
  late String roomId;

  @override
  void initState() {
    super.initState();
    _opponent = AssetImage('assets/images/dinosaur1.png');
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
    wsService = WebSocketService.getInstance(widget.sender, widget.random ? "random" : "chat");
    if (widget.random) {
      wsService.messages.listen((data) {
        try {
          final Message message = Message.fromJson(jsonDecode(data));
          setState(() {
            messages.add(message);
          });
          print('📨 메시지 수신 및 저장 random: ${message.content}');
        } catch (e) {
          print('❌ 메시지 파싱 실패 random: $e');
        }
      }, onDone: () {
        print('🔌 WebSocket random 연결 종료');
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            Navigator.pop(context);
          }
        });
      }, onError: (error) {
        print('❌ WebSocket random 오류: $error');
      });
    }
    roomId = Room.getRoomId(widget.sender, widget.receiver);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _textController.dispose();
    if (widget.random) {
      wsService.sendMessage(Message(id: 1, content: "text", sender: widget.sender, receiver: widget.receiver, createdAt: DateTime.now()).toJson());
      wsService.disconnect();
    }
    super.dispose();
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  void _sendMessage() {
    final text = _textController.text.trim();
    _textController.clear();
    if (text.isEmpty) return;

    wsService.sendMessage(Message(id: null, content: text, sender: widget.sender, receiver: widget.receiver, createdAt: DateTime.now()).toJson());
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
  }

  Widget buildDate(DateTime time) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.grey.shade300,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            Time.getFormatDateS(time),
            style: const TextStyle(fontSize: 16, color: Colors.black54),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: CircleAvatar(
          radius: 20,
          backgroundImage: _opponent,
          backgroundColor: const Color.fromARGB(255, 209, 209, 209),
        ),
        actions: const [
          Icon(Icons.person_add),
          SizedBox(width: 10),
          Icon(Icons.report_gmailerrorred),
          SizedBox(width: 10),
        ],
      ),
      body: Container(
        color: const Color.fromARGB(255, 252, 230, 223),
        child: widget.random
            ? ListView.builder(
                controller: _scrollController,
                itemCount: messages.length,
                itemBuilder: (context, index) {
                  return Column(
                    crossAxisAlignment: messages[index].sender == widget.sender ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                    children: [
                      if (index == 0) buildDate(messages[index].createdAt),
                      MessageWidget(message: messages[index], userId: widget.sender),
                      if (index < messages.length - 1)
                        if (Time.compareTime(messages[index].createdAt, messages[index + 1].createdAt) == 1) buildDate(messages[index + 1].createdAt),
                    ],
                  );
                },
              )
            : app_provider.Consumer<MessageProvider>(
                builder: (context, messageProvider, child) {
                  final messages = messageProvider.getMessagesForRoom(roomId);
                  WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
                  return ListView.builder(
                    controller: _scrollController,
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      return Column(
                        crossAxisAlignment: messages[index].sender == widget.sender ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                        children: [
                          if (index == 0) buildDate(messages[index].createdAt),
                          MessageWidget(message: messages[index], userId: widget.sender),
                          if (index < messages.length - 1)
                            if (Time.compareTime(messages[index].createdAt, messages[index + 1].createdAt) == 1) buildDate(messages[index + 1].createdAt),
                        ],
                      );
                    },
                  );
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
                decoration: const InputDecoration(
                  labelText: "메시지 입력",
                  border: OutlineInputBorder(),
                ),
                onSubmitted: (_) => _sendMessage(),
              ),
            ),
            const SizedBox(width: 10),
            ElevatedButton(
              onPressed: _sendMessage,
              child: const Icon(Icons.send),
            ),
          ],
        ),
      ),
    );
  }
}
