import 'package:buck_tanley_app/pages/ChattingPage.dart';
import 'package:buck_tanley_app/pages/MatchingPage.dart';
import 'package:flutter/material.dart';

class PageRouter extends StatefulWidget {
  const PageRouter({super.key});

  @override
  State<PageRouter> createState() => _PageRouterState();
}

class _PageRouterState extends State<PageRouter> {
  int tab = 0;
  final PageController pageController = PageController();

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      MatchingPage(),
      ElevatedButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ChattingPage()),
          );
        },
        child: Text("채팅"),
      ),
      ChattingPage(),
      ChattingPage(),
    ];
    return Scaffold(
      body: PageView(
        controller: pageController,
        children: pages,
        onPageChanged: (index) {
          setState(() {
            tab = index;
          });
        },
      ),
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(
          splashColor: Colors.transparent, // 클릭 시 효과 제거
          // hoverColor: Colors.transparent, // 호버 효과 제거
        ),
        child: BottomNavigationBar(
          currentIndex: tab,
          onTap: (index) {
            pageController.animateToPage(
              index,
              duration: Duration(milliseconds: 300),
              curve: Curves.easeInOut,
            );
            setState(() {
              tab = index;
            });
          },
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.replay), label: '매칭'),
            BottomNavigationBarItem(icon: Icon(Icons.people), label: '친구'),
            BottomNavigationBarItem(icon: Icon(Icons.forum), label: '채팅'),
            BottomNavigationBarItem(icon: Icon(Icons.settings), label: '설정'),
          ],
          selectedItemColor: Colors.blue, // 선택된 아이템 색상
          unselectedItemColor: Colors.grey, // 선택되지 않은 아이템 색상
          backgroundColor: Colors.grey.shade200, // 배경색
          iconSize: 30, // 아이콘 크기
          selectedFontSize: 16, // 선택된 폰트 크기
          unselectedFontSize: 14, // 선택되지 않은 폰트 크기
          type: BottomNavigationBarType.fixed, // 아이템 개수가 4개 이상이면 필수
        ),
      ),
    );
  }
}
