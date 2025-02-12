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
  List<Message> messages = [
    Message(message: "안녕", type: 2, time: DateTime.parse("2025-02-09T14:30:00.123+09:00")),
    Message(message: "뭐함", type: 2, time: DateTime.parse("2025-02-09T14:31:00.123+09:00")),
    Message(message: "ㅇㅉ", type: 1, time: DateTime.parse("2025-02-09T14:32:00.123+09:00")),
    Message(message: "조용히 해", type: 2, time: DateTime.parse("2025-02-09T14:30:00.123+09:00")),
    Message(message: "놀고 싶다", type: 2, time: DateTime.parse("2025-02-10T14:30:00.123+09:00")),
    Message(message: "프로젝트나 해", type: 1, time: DateTime.parse("2025-02-10T14:30:00.123+09:00")),
    Message(message: "하는 중", type: 2, time: DateTime.parse("2025-02-10T14:30:00.123+09:00")),
    Message(message: "쌉쳐", type: 2, time: DateTime.parse("2025-02-10T14:30:00.123+09:00")),
    Message(message: "왜 ㅈㄹ임", type: 2, time: DateTime.parse("2025-02-10T14:30:00.123+09:00")),
    Message(message: "? 니가 ㅈㄹ 하는데?", type: 1, time: DateTime.parse("2025-02-10T14:30:00.123+09:00")),
    Message(message: "이 새기 뭐지", type: 1, time: DateTime.parse("2025-02-11T14:30:00.123+09:00")),
    Message(message: "정신 나감?", type: 1, time: DateTime.parse("2025-02-11T14:30:00.123+09:00")),
    Message(message: "ㅇㅇㅇ", type: 2, time: DateTime.parse("2025-02-11T14:30:00.123+09:00")),
    Message(message: "아무것도 하기 싫어서", type: 2, time: DateTime.parse("2025-02-11T14:30:00.123+09:00")),
    Message(message: "그럼 쳐자", type: 1, time: DateTime.parse("2025-02-11T14:30:00.123+09:00")),
    Message(message: "그것도 시름", type: 2, time: DateTime.parse("2025-02-12T14:30:00.123+09:00")),
    Message(message: "뭐 어쩌라고 ㅅㅂ", type: 1, time: DateTime.parse("2025-02-12T14:30:00.123+09:00")),
    Message(message: "왜 욕행..ㅠㅠ", type: 2, time: DateTime.parse("2025-02-12T14:30:00.123+09:00")),
    Message(message: "ㄲㅈ", type: 1, time: DateTime.parse("2025-02-12T14:30:00.123+09:00")),
    Message(message: "뭐라도 채워야지", type: 1, time: DateTime.parse("2025-02-12T14:30:00.123+09:00")),
    Message(message: "프로젝트에서 플루터 내용 잘 확인하고 테스트 해봐 이 페이지는 채팅 페이지야", type: 1, time: DateTime.parse("2025-02-12T14:30:00.123+09:00")),
    Message(message: "ㅇㅉ", type: 2, time: DateTime.parse("2025-02-12T14:30:00.123+09:00")),
    Message(message: "ㄷㅊ", type: 1, time: DateTime.parse("2025-02-12T14:30:00.123+09:00")),
    Message(message: "넹", type: 2, time: DateTime.parse("2025-02-12T14:30:00.123+09:00")),
    Message(message: "내가 지금 뭐하는 걸까 이런 생각이 드네 이 글을 쓰는 것도 뭐하는 짓인가 어쩌라고 테스트는 해야할거 아니야 긴문장도!!", type: 1, time: DateTime.parse("2025-02-12T14:30:00.123+09:00")),
    Message(message: "그러니까 할 수 밖에 없지", type: 1, time: DateTime.parse("2025-02-12T14:30:00.123+09:00")),
    Message(message: "ㅇㅇㅇ", type: 2, time: DateTime.parse("2025-02-12T14:30:00.123+09:00")),
    Message(message: "나도 해봄", type: 2, time: DateTime.parse("2025-02-12T14:30:00.123+09:00")),
    Message(message: "뭐래 하기 싫은데 아무말이나 막 적어야 하니까 그냥 하는 거지 원래였으면 안함 ㅅㄱ", type: 2, time: DateTime.parse("2025-02-12T14:30:00.123+09:00")),
    Message(message: "굿 잘되겠지", type: 1, time: DateTime.parse("2025-02-12T14:30:00.123+09:00")),
    Message(message: "그러겠지", type: 2, time: DateTime.parse("2025-02-12T14:30:00.123+09:00")),
    Message(message: "오케이 확인", type: 1, time: DateTime.parse("2025-02-12T14:30:00.123+09:00")),
    Message(message: "끝", type: 1, time: DateTime.parse("2025-02-12T14:30:00.123+09:00")),
  ];

  @override
  void initState() {
    super.initState();
    _opponent = AssetImage('assets/images/dinosaur1.png');
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _textController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: Duration(milliseconds: 100),
      curve: Curves.easeOut,
    );

    Future.delayed(Duration(milliseconds: 100), () {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: Duration(milliseconds: 100),
        curve: Curves.easeOut,
      );
    });
  }

  void _sendMessage() {
    if (_textController.text == "") return;

    print("입력된 값: ${_textController.text}");
    setState(() {
      messages.add(Message(message: _textController.text, type: 1, time: DateTime.now()));
      _textController.text = "";
    });

    _scrollToBottom();
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
        actions: [
          Icon(Icons.person_add),
          Icon(Icons.report_gmailerrorred),
        ],
      ),
      body: Container(
        color: const Color.fromARGB(255, 252, 230, 223),
        child: ListView.builder(
          controller: _scrollController,
          itemCount: messages.length,
          itemBuilder: (context, index) {
            List<Widget> widgets = [];
            widgets.add(MessageWidget(message: messages[index]));

            if (index < messages.length - 1) {
              DateTime now = messages[index].time;
              DateTime next = messages[index + 1].time;
              if (now.isBefore(next) && (now.year != next.year || now.month != next.month || now.day != next.day)) {
                widgets.add(Padding(
                  padding: const EdgeInsets.all(10),
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(border: Border(bottom: BorderSide())),
                    child: Center(
                      child: Text(
                        "${messages[index + 1].time.month}/${messages[index + 1].time.day}",
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                  ),
                ));
              }
            }

            return Column(children: widgets);
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
