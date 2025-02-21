import 'dart:convert';
import 'dart:io' as io;
import 'dart:typed_data';

import 'package:buck_tanley_app/models/entity/User.dart';
import 'package:buck_tanley_app/utils/Server.dart';
import 'package:buck_tanley_app/widgets/AdBanner.dart';
import 'package:buck_tanley_app/widgets/LogoAppBar.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nicknameController =
      TextEditingController(); // 닉네임
  final TextEditingController _bioController = TextEditingController(); // 자기소개
  final TextEditingController _ageController = TextEditingController(); // 생년월일
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  bool selectedGender=true;
  Uint8List? _webImage; // 웹 환경 이미지
  io.File? _image; // 모바일 환경 이미지

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      if (kIsWeb) {
        final bytes = await pickedFile.readAsBytes();
        setState(() {
          _webImage = bytes;
        });
      } else {
        setState(() {
          _image = io.File(pickedFile.path);
        });
      }
    }
  }

  Future<void> _registerUser() async {
    final User user = User(
        id: null,
        userId: _idController.text,
        userPw: _passwordController.text,
        name: _nicknameController.text,
        phone: _phoneController.text,
        email: _emailController.text,
        image: encodeImage(),
        introduction: _bioController.text,
        age: int.tryParse(_ageController.text) ?? 0,
        gender: selectedGender,
        status: 0,
        createdAt: DateTime.now());

    try {
      final response = await http.post(Uri.parse('${Server.url}/users/register'),
          headers: Server.header, body: jsonEncode(user.toJson()));
      final responseData = jsonDecode(response.body);

      if (response.statusCode == 201) {
        _showMessage("회원가입 성공: ${responseData['message']}");
      } else {
        _showMessage("회원가입 실패: ${responseData['message']}");
      }
    } catch (e) {
      _showMessage("회원가입 중 오류 발생 $e");
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  String? encodeImage() {
    if (_webImage != null) {
      return base64Encode(_webImage!);
    } else if (_image != null) {
      return base64Encode(_image!.readAsBytesSync());
    }
    return null;
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
                        onTap: _pickImage,
                        child: CircleAvatar(
                          radius: 40,
                          backgroundColor: Colors.grey[400],
                          backgroundImage: kIsWeb
                              ? (_webImage != null
                                  ? MemoryImage(_webImage!) // 웹 환경 이미지
                                  : null)
                              : (_image != null
                                  ? FileImage(_image!) // 모바일 환경 이미지
                                  : null),
                          child: (_image == null && _webImage == null)
                              ? const Icon(
                                  Icons.camera_alt,
                                  size: 40,
                                  color: Colors.white10,
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
                      controller: _passwordController,
                      decoration: const InputDecoration(labelText: '비밀번호'),
                      obscureText: true,
                    ),
                    const SizedBox(height: 20),

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
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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
