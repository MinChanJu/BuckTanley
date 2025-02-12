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
    Freind(image: "", name: "김민수", message: "안녕ㄴㄴㄴㄴㄴㄴㄴㄴㄴㄴㄴㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㄴㄴㄴㄴㄴㄴㄴㄴㄴㄴㄴㄴㄴㄴㄴㄴㄴㄴㄴㄴㄴㄴㄴㄴㄴㄴㄴㄴㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㄴㄴㄴㄴㄴㄴㄴㄴㄴㄴㄴㄴㄴㄴㄴㄴㄴㄴㄴ", status: 2),
    Freind(image: "", name: "이영희", message: "해", status: 1),
    Freind(image: "", name: "박철수", message: "어쩔", status: 0),
    Freind(image: "", name: "김이박", message: "뭐함", status: 3),
    Freind(image: "", name: "김순자", message: "조용", status: 0),
    Freind(image: "", name: "박친수", message: "닥쳐", status: 2),
    Freind(image: "", name: "닉네임", message: "벅텐리", status: 3),
    Freind(image: "", name: "비스코", message: "아라라라", status: 1),
    Freind(image: "", name: "아주대", message: "쉿", status: 3),
    Freind(image: "", name: "가위", message: "굿", status: 1),
    Freind(image: "", name: "보배", message: "나이스", status: 1),
    Freind(image: "", name: "커피짱", message: "심심해", status: 3),
    Freind(image: "", name: "마우스 아무거나", message: "좀 조용히 좀 해봐", status: 2),
    Freind(image: "", name: "벅텐리가 뭐야", message: "ㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋ", status: 3),
    Freind(image: "", name: "거치대", message: "ㅇㅇ", status: 1),
    Freind(image: "", name: "모니터", message: "ㅇㄷ", status: 3),
    Freind(image: "", name: "맥북", message: "프로젝트", status: 2),
    Freind(image: "", name: "텀블러", message: "미니게임할까", status: 3),
    Freind(image: "", name: "물티슈", message: "플루터", status: 3),
    Freind(image: "", name: "달력", message: "레전드", status: 0),
    Freind(image: "", name: "담요", message: "다트", status: 2),
    Freind(image: "", name: "아무거나 해", message: "구글짱", status: 3),
  ];

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            width: screenWidth,
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: Colors.grey, width: 1))
            ),
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
                "벅텐리",
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
