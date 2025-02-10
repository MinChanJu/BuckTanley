import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nicknameController = TextEditingController(); // 닉네임
  final TextEditingController _bioController = TextEditingController(); // 자기소개
  final TextEditingController _ageController = TextEditingController(); // 생년월일
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController(); // 이메일
  String? selectedGender;
  File? _image;

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: SizedBox(
          height: 50,
          child: Image.asset('assets/images/BuckTanleyLogo.png',
              fit: BoxFit.contain),
        ),
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),
          const Center(
            child: Text(
              "회원가입",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: Center(
              child: Padding(
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
                          child: Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              color: Colors.grey[400],
                              borderRadius: BorderRadius.circular(10),
                              image: _image != null
                                  ? DecorationImage(
                                      image: FileImage(_image!),
                                      fit: BoxFit.cover,
                                    )
                                  : null,
                            ),
                            child: _image == null
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
                          hintText: '000000',
                          labelText: '생년월일',
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
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      Row(
                        children: [
                          Radio<String>(
                            value: "남성",
                            groupValue: selectedGender,
                            onChanged: (value) {
                              setState(() {
                                selectedGender = value;
                              });
                            },
                          ),
                          const Text("남성"),
                          const SizedBox(width: 20),
                          Radio<String>(
                            value: "여성",
                            groupValue: selectedGender,
                            onChanged: (value) {
                              setState(() {
                                selectedGender = value;
                              });
                            },
                          ),
                          const Text("여성"),
                        ],
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        "자기소개 (20자 미만)",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
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
                          onPressed: () {
                            print("ID: \${_idController.text}");
                            print("비밀번호: \${_passwordController.text}");
                            print("성별: \$selectedGender");
                            print("자기소개: \${_bioController.text}");
                          },
                          child: const Text("가입하기"),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      // 광고 영역  - 배너 클릭시 링크 연결되게 수정해야 하니 버튼으로 변경해야함
      bottomNavigationBar: Container(
        color: Colors.grey[300],
        height: 100,
        width: double.infinity,
        alignment: Alignment.center,
        child: const Text('광고'),
      ),
    );
  }
}
