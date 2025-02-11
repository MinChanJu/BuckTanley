import 'package:buck_tanley_app/models/Freind.dart';
import 'package:buck_tanley_app/widgets/FreindWidget.dart';
import 'package:flutter/material.dart';

class FreindListPage extends StatefulWidget {
  const FreindListPage({super.key});

  @override
  State<FreindListPage> createState() => _FreindListPageState();
}

class _FreindListPageState extends State<FreindListPage> {
  List<Freind> freinds = [
    Freind(image: "", name: "김민수", message: "안녕", status: 2),
    Freind(image: "", name: "이영희", message: "ㅎㅇ", status: 1),
    Freind(image: "", name: "박철수", message: "ㅇㅉ", status: 0),
    Freind(image: "", name: "김이박", message: "그만", status: 3),
    Freind(image: "", name: "김이박", message: "그만", status: 3),
    Freind(image: "", name: "김이박", message: "그만", status: 3),
    Freind(image: "", name: "김이박", message: "그만", status: 3),
    Freind(image: "", name: "김이박", message: "그만", status: 3),
    Freind(image: "", name: "김이박", message: "그만", status: 3),
    Freind(image: "", name: "김이박", message: "그만", status: 3),
    Freind(image: "", name: "김이박", message: "그만", status: 3),
    Freind(image: "", name: "김이박", message: "그만", status: 3),
    Freind(image: "", name: "김이박", message: "그만", status: 3),
    Freind(image: "", name: "김이박", message: "그만", status: 3),
    Freind(image: "", name: "김이박", message: "그만", status: 3),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
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
                "벅텐리",
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Expanded(child: Container()),
              Text("안녕하세요 벅텐리입니다."),
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
