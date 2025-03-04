import 'dart:convert';

import 'package:buck_tanley_app/SetUp.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class MyPageTab extends StatefulWidget {
  const MyPageTab({super.key});

  @override
  State<MyPageTab> createState() => _MyPageTab();
}

class _MyPageTab extends State<MyPageTab> {
  final LoginDTO loginDTO = getIt<UserProvider>().loginDTO!;
  final TextEditingController _nicknameController = TextEditingController(); // 닉네임
  final TextEditingController _bioController = TextEditingController(); // 자기소개
  final TextEditingController _ageController = TextEditingController(); // 생년월일
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  bool selectedGender = true;
  Imager? imager;

  @override
  void dispose() {
    _nicknameController.dispose();
    _bioController.dispose();
    _ageController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _updateUser() async {
    final User user = User(
      id: null,
      userId: loginDTO.userId,
      userPw: loginDTO.userPw,
      nickname: _nicknameController.text,
      phone: _phoneController.text,
      email: _emailController.text,
      image: ImageConverter.encodeImage(imager),
      introduction: _bioController.text,
      gender: selectedGender,
      age: int.tryParse(_ageController.text) ?? 0,
      status: 0,
      createdAt: DateTime.now(),
    );

    try {
      final response = await http.post(Uri.parse('${Server.userUrl}/update'), headers: Server.header, body: jsonEncode(user.toJson()));
      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200) {
        Show.snackbar("✅ 회원정보 수정 성공: ${responseData['message']}");
      } else {
        Show.snackbar("❌ 회원정보 수정 실패: ${responseData['message']}");
      }
    } catch (e) {
      Show.snackbar("⚒ 회원정보 수정 중 오류 발생 $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const LogoAppBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            const Center(
              child: Text(
                "회원정보 수정",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                padding: const EdgeInsets.all(16),
                width: 300,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 5,
                      spreadRadius: 2,
                      offset: Offset(2, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // 프로필 이미지
                    Center(
                      child: GestureDetector(
                        onTap: () async {
                          final image = await ImageConverter.pickImage();
                          if (mounted && image != null) {
                            setState(() {
                              imager = image;
                            });
                          }
                        },
                        child: CircleAvatar(
                          radius: 40,
                          backgroundColor: Colors.grey[400],
                          backgroundImage: imager == null ? null :ImageConverter.getImage(imager),
                          child: (imager == null || (imager!.mobileImage == null && imager!.webImage == null))
                              ? const Icon(
                                  Icons.camera_alt,
                                  size: 40,
                                  color: Colors.white70,
                                )
                              : null,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),

                    TextField(
                      controller: _nicknameController,
                      decoration: const InputDecoration(labelText: '닉네임'),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: _ageController,
                      decoration: const InputDecoration(
                        labelText: '나이',
                      ),
                    ),
                    const SizedBox(height: 10),

                    //비밀번호 찾기용
                    TextField(
                      controller: _phoneController,
                      decoration: const InputDecoration(
                        hintText: '010-0000-0000',
                        labelText: '전화번호',
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: _emailController,
                      decoration: const InputDecoration(labelText: 'e-mail'),
                    ),
                    const SizedBox(height: 20),

                    const Text(
                      "성별",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    Row(
                      children: [
                        Radio<bool>(
                          value: true,
                          groupValue: selectedGender,
                          onChanged: (value) {
                            setState(() {
                              selectedGender = value!;
                            });
                          },
                        ),
                        const Text("남성"),
                        const SizedBox(width: 20),
                        Radio<bool>(
                          value: false,
                          groupValue: selectedGender,
                          onChanged: (value) {
                            setState(() {
                              selectedGender = value!;
                            });
                          },
                        ),
                        const Text("여성"),
                      ],
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      "자기소개 (20자 미만)",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    TextField(
                      controller: _bioController,
                      maxLength: 20,
                      decoration: const InputDecoration(
                        hintText: "자기소개를 입력하세요.",
                        counterText: "",
                      ),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _updateUser,
                        child: const Text("가입하기"),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      // 광고 영역  - 배너 클릭시 링크 연결되게 수정해야 하니 버튼으로 변경해야함
      bottomNavigationBar: const AdBanner(),
    );
  }
}
