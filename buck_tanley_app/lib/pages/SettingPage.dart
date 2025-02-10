import 'package:buck_tanley_app/widgets/AdBanner.dart';
import 'package:buck_tanley_app/widgets/LogoAppBar.dart';
import 'package:buck_tanley_app/pages/settings/MyPageTab.dart';
import 'package:buck_tanley_app/pages/settings/NotificationTab.dart';
import 'package:buck_tanley_app/pages/settings/SecurityTab.dart';
import 'package:buck_tanley_app/pages/settings/HelpSupportTab.dart';
import 'package:buck_tanley_app/pages/settings/AppInfoTab.dart';
import 'package:flutter/material.dart';

class SettingPage extends StatelessWidget {
  const SettingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> settings = [
      {"title": "마이페이지", "icon": Icons.person, "page": const MyPageTab()}, // 마이페이지 - 기본 정보 변경 / 차단 제어
      {"title": "알림", "icon": Icons.notifications, "page": const NotificationTab()}, // 푸쉬 알림 설정 - 매칭 및 친구 요청, 채팅 알림
      {"title": "보안", "icon": Icons.lock, "page": const SecurityTab()}, // 보안 및 로그인 - 비밀번호 변경 / 회원 탈퇴
      {"title": "도움말 및 고객지원", "icon": Icons.help, "page": const HelpSupportTab()}, // 도움말 및 고객지원 - FAQ / 약관 안내
      {"title": "앱 정보", "icon": Icons.info, "page": const AppInfoTab()}, // 앱 버전 정보 제공
    ];

    return Scaffold(
      appBar: const LogoAppBar(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.builder(
          itemCount: settings.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 1.5,
          ),
          itemBuilder: (context, index) {
            return InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => settings[index]["page"]),
                );
              },
              borderRadius: BorderRadius.circular(10),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 5,
                      spreadRadius: 2,
                      offset: const Offset(2, 2),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(settings[index]["icon"], size: 40, color: Colors.blueAccent),
                    const SizedBox(height: 10),
                    Text(
                      settings[index]["title"],
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
      bottomNavigationBar: const AdBanner(),
    );
  }
}
