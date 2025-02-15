import 'dart:convert';

import 'package:buck_tanley_app/models/Message.dart';
import 'package:buck_tanley_app/services/WebSocketService.dart';
import 'package:buck_tanley_app/widgets/MessageWidget.dart';
import 'package:flutter/material.dart';

class ChattingPage extends StatefulWidget {
  final String sender;
  final String receiver;
  const ChattingPage({super.key, required this.sender, required this.receiver});

  @override
  State<ChattingPage> createState() => _ChattingPageState();
}

class _ChattingPageState extends State<ChattingPage> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _textController = TextEditingController();
  late WebSocketService wsService;
  late AssetImage _opponent;
  List<Message> messages = [];

  @override
  void initState() {
    super.initState();
    _opponent = AssetImage('assets/images/dinosaur1.png');
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
    wsService = WebSocketService.getInstance(widget.sender);
    if (wsService.messages.isBroadcast) {
      print('🔍 WebSocket 메시지 리스너 연결 준비...');
      wsService.messages.listen((data) {
        print('📨 서버 메시지 수신: $data');
        try {
          final message = Message.fromJson(jsonDecode(data));
          print('✅ 디코딩 성공: $message');
          if (mounted) {
            setState(() => messages.add(message));
          }
        } catch (e) {
          print('❌ JSON 디코딩 실패: $e');
        }
      });
    } else {
      print('⚠️ WebSocket 메시지 리스너가 이미 연결됨');
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _textController.dispose();
    // _webSocketService.disconnect();
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

    wsService.sendMessage(Message(message: text, sender: widget.sender, receiver: widget.receiver, time: DateTime.now()));
    _scrollToBottom();
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
        child: ListView.builder(
          controller: _scrollController,
          itemCount: messages.length,
          itemBuilder: (context, index) {
            return Column(
              crossAxisAlignment: messages[index].sender == widget.sender ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                MessageWidget(message: messages[index], userId: widget.sender),
                if (index < messages.length - 1)
                  if (_shouldShowDateDivider(index)) _buildDateDivider(messages[index + 1].time),
              ],
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

  bool _shouldShowDateDivider(int index) {
    final current = messages[index].time;
    final next = messages[index + 1].time;
    return current.year != next.year || current.month != next.month || current.day != next.day;
  }

  Widget _buildDateDivider(DateTime date) {
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
            "${date.year}/${date.month}/${date.day}",
            style: const TextStyle(fontSize: 16, color: Colors.black54),
          ),
        ),
      ),
    );
  }
}
