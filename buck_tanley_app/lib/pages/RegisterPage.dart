import 'dart:convert';

import 'package:buck_tanley_app/core/Import.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _pwController = TextEditingController();
  final TextEditingController _nicknameController = TextEditingController(); // 닉네임
  final TextEditingController _bioController = TextEditingController(); // 자기소개
  int selectedAge = 20; // 기본 나이
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  bool selectedGender = true;
  Imager? imager;

  @override
  void dispose() {
    _idController.dispose();
    _pwController.dispose();
    _nicknameController.dispose();
    _bioController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _registerUser() async {
    final User user = User(
      id: null,
      userId: _idController.text,
      userPw: _pwController.text,
      nickname: _nicknameController.text,
      phone: _phoneController.text,
      email: _emailController.text,
      image: null,
      introduction: _bioController.text,
      gender: selectedGender,
      age: selectedAge,
      status: 0,
      createdAt: DateTime.now(),
    );

    var request = http.MultipartRequest("POST", Uri.parse('${Server.userUrl}/register'));
    request.headers.addAll({"Accept": "application/json; charset=UTF-8"});

    if (Server.platform == "web" && imager?.webImage != null) {
      // 🌐 **웹 환경 (Uint8List -> MultipartFile)**
      request.files.add(http.MultipartFile.fromBytes(
        'image',
        imager!.webImage!,
        filename: "profile.png",
      ));
    } else if (Server.platform != "web" && imager?.mobileImage != null) {
      // 📱 **모바일 환경 (File 사용)**
      request.files.add(await http.MultipartFile.fromPath(
        'image',
        imager!.mobileImage!.path,
        filename: "profile.png",
      ));
    }

    // JSON Body 데이터 추가 (User 객체)
    request.fields['user'] = jsonEncode(user.toJson());

    try {
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);
      final responseData = jsonDecode(response.body);

      if (response.statusCode == 201) {
        print("✅ 회원가입 성공: ${responseData['message']}");
        Show.snackbar("✅ 회원가입 성공: ${responseData['message']}");
        Navigate.pop();
      } else {
        print("❌ 회원가입 실패: ${responseData['message']}");
        Show.snackbar("❌ 회원가입 실패: ${responseData['message']}");
      }
    } catch (e) {
      print("❌ 회원가입 중 오류 발생: $e");
      Show.snackbar("❌ 회원가입 중 오류 발생: $e");
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
                "회원가입",
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
                          backgroundImage: imager == null ? null : ImageConverter.getImage(imager),
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
                      controller: _idController,
                      decoration: const InputDecoration(labelText: 'ID'),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: _pwController,
                      decoration: const InputDecoration(labelText: '비밀번호'),
                      obscureText: true,
                    ),
                    const SizedBox(height: 20),

                    TextField(
                      controller: _nicknameController,
                      decoration: const InputDecoration(labelText: '닉네임'),
                    ),
                    const SizedBox(height: 10),

                    //비밀번호 찾기용
                    TextField(
                      controller: _phoneController,
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      maxLength: 11,
                      decoration: const InputDecoration(
                        hintText: '01012345678',
                        labelText: '전화번호',
                        counterText: "",
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: _emailController,
                      decoration: const InputDecoration(labelText: 'e-mail'),
                    ),
                    const SizedBox(height: 10),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          '나이',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        DropdownButton<int>(
                          value: selectedAge,
                          items: List.generate(100, (index) => index).map((int value) {
                            return DropdownMenuItem<int>(
                              value: value,
                              child: Text(value.toString()),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              selectedAge = value!;
                            });
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
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
                            const SizedBox(width: 10),
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
                      ],
                    ),
                    const SizedBox(height: 10),
                    
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
                        onPressed: _registerUser,
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
