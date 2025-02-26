import 'dart:convert';

import 'package:buck_tanley_app/SetUp.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChattingPage extends StatefulWidget {
  final UserDTO partner;
  final ImageProvider partnerImage;
  final bool random;
  const ChattingPage({super.key, required this.partner, required this.partnerImage, required this.random});

  @override
  State<ChattingPage> createState() => _ChattingPageState();
}

class _ChattingPageState extends State<ChattingPage> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _textController = TextEditingController();
  final String userId = getIt<UserProvider>().user!.userId;
  late WebSocketService wsService;
  final List<Message> messages = [];
  late String roomId;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
    wsService = WebSocketService.getInstance(widget.random ? "random" : "chat");
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
    roomId = Room.getRoomId(userId, widget.partner.userId);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _textController.dispose();
    if (widget.random) {
      wsService.sendMessage(Message(id: 1, content: "text", sender: userId, receiver: widget.partner.userId, createdAt: DateTime.now()).toJson());
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

    Message sendMessage = Message(id: null, content: text, sender: userId, receiver: widget.partner.userId, createdAt: DateTime.now());
    wsService.sendMessage(sendMessage.toJson());
  }

  void _addFriend() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('친구 추가'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('이 사람을 친구 추가 하시겠습니까?'),
              const SizedBox(height: 10),
              TextButton(
                onPressed: () {
                  Navigate.pushFriendDetail(widget.partner, widget.partnerImage);
                },
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 20,
                      backgroundImage: widget.partnerImage,
                      backgroundColor: const Color.fromARGB(255, 209, 209, 209),
                    ),
                    const SizedBox(width: 10),
                    Text(widget.partner.nickname),
                  ],
                ),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                print("친구 추가 취소");
              },
              child: const Text('취소'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Message sendMessage = Message(id: 2, content: "친구 추가", sender: userId, receiver: widget.partner.userId, createdAt: DateTime.now());
                print("친구 추가 요청 : ${sendMessage.toJson()}");
                wsService.sendMessage(sendMessage.toJson());
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('친구 추가 요청을 보냈습니다.')),
                );
              },
              child: const Text('확인'),
            ),
          ],
        );
      },
    );

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

  Widget buildMessage(List<Message> messages) {
    return ListView.builder(
      controller: _scrollController,
      itemCount: messages.length,
      itemBuilder: (context, index) {
        return Column(
          crossAxisAlignment: messages[index].sender == userId ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            if (index == 0) buildDate(messages[index].createdAt),
            MessageWidget(message: messages[index], userId: userId),
            if (index < messages.length - 1)
              if (Time.compareTime(messages[index].createdAt, messages[index + 1].createdAt) == 1) buildDate(messages[index + 1].createdAt),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer: MenuWidget(userDTO: widget.partner, imageProvider: widget.partnerImage),
      appBar: AppBar(
        title: Center(
          child: TextButton(
            onPressed: () {
              Navigate.pushFriendDetail(widget.partner, widget.partnerImage);
            },
            child: CircleAvatar(
              radius: 20,
              backgroundImage: widget.partnerImage,
              backgroundColor: const Color.fromARGB(255, 209, 209, 209),
            ),
          ),
        ),
        actions: [
          if (widget.random)
            IconButton(
              onPressed: _addFriend,
              icon: Icon(Icons.person_add),
            ),
          Builder(
            builder: (BuildContext context) {
              return IconButton(
                onPressed: () {
                  Scaffold.of(context).openEndDrawer();
                },
                icon: Icon(Icons.menu_rounded),
              );
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          Container(
            color: const Color.fromARGB(255, 252, 230, 223),
            child: widget.random
                ? buildMessage(messages)
                : Consumer<MessageProvider>(
                    builder: (context, messageProvider, child) {
                      final messages = messageProvider.getMessagesForRoom(roomId);
                      WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
                      return buildMessage(messages);
                    },
                  ),
          ),
        ],
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
