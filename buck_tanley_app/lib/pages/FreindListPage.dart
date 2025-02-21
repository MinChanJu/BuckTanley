import 'package:buck_tanley_app/models/entity/Freind.dart';
import 'package:buck_tanley_app/widgets/FreindWidget.dart';
import 'package:buck_tanley_app/provider/UserProvider.dart';
import 'package:provider/provider.dart' as app_provider;
import 'package:flutter/material.dart';

class FreindListPage extends StatefulWidget {
  const FreindListPage({super.key});

  @override
  State<FreindListPage> createState() => _FreindListPageState();
}

class _FreindListPageState extends State<FreindListPage> {
  List<Freind> freinds = [
    Freind(id: null, userId1: "나", userId2: "김민수", status: 0, createdAt: DateTime.now()),
    Freind(id: null, userId1: "나", userId2: "김민수", status: 0, createdAt: DateTime.now()),
    Freind(id: null, userId1: "나", userId2: "김민수", status: 0, createdAt: DateTime.now()),
    Freind(id: null, userId1: "나", userId2: "김민수", status: 0, createdAt: DateTime.now()),
    Freind(id: null, userId1: "나", userId2: "김민수", status: 0, createdAt: DateTime.now()),
    Freind(id: null, userId1: "나", userId2: "김민수", status: 0, createdAt: DateTime.now()),
    Freind(id: null, userId1: "나", userId2: "김민수", status: 0, createdAt: DateTime.now()),
    Freind(id: null, userId1: "나", userId2: "김민수", status: 0, createdAt: DateTime.now()),
    Freind(id: null, userId1: "나", userId2: "김민수", status: 0, createdAt: DateTime.now()),
    Freind(id: null, userId1: "나", userId2: "김민수", status: 0, createdAt: DateTime.now()),
    Freind(id: null, userId1: "나", userId2: "김민수", status: 0, createdAt: DateTime.now()),
    Freind(id: null, userId1: "나", userId2: "김민수", status: 0, createdAt: DateTime.now()),
    Freind(id: null, userId1: "나", userId2: "김민수", status: 0, createdAt: DateTime.now()),
    Freind(id: null, userId1: "나", userId2: "김민수", status: 0, createdAt: DateTime.now()),
    Freind(id: null, userId1: "나", userId2: "김민수", status: 0, createdAt: DateTime.now()),
    Freind(id: null, userId1: "나", userId2: "김민수", status: 0, createdAt: DateTime.now()),
    Freind(id: null, userId1: "나", userId2: "김민수", status: 0, createdAt: DateTime.now()),
    Freind(id: null, userId1: "나", userId2: "김민수", status: 0, createdAt: DateTime.now()),
    Freind(id: null, userId1: "나", userId2: "김민수", status: 0, createdAt: DateTime.now()),
    Freind(id: null, userId1: "나", userId2: "김민수", status: 0, createdAt: DateTime.now()),
    Freind(id: null, userId1: "나", userId2: "김민수", status: 0, createdAt: DateTime.now()),
  ];

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    String? token = app_provider.Provider.of<UserProvider>(context, listen: false).token;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            width: screenWidth,
            decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Colors.grey, width: 1))),
            child: Text("친구 목록", style: TextStyle(fontSize: 25)),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            children: [
              CircleAvatar(
                radius: 50,
                backgroundImage: AssetImage("assets/images/BuckTanleyLogo.png"),
              ),
              SizedBox(width: 20),
              Text(
                token ?? "없음",
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(width: 20),
              Expanded(child: Text("안녕하세요 벅텐리입니다.")),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: freinds.length,
            itemBuilder: (context, index) {
              return FreindWidget(freind: freinds[index]);
            },
          ),
        ),
      ],
    );
  }
}
