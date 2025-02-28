import 'dart:convert';

import 'package:buck_tanley_app/SetUp.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class UserProvider with ChangeNotifier {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  User? _user;
  LoginDTO? _loginDTO;
  ImageProvider _userImage = ImageConverter.getImage(null);

  User? get user => _user;
  LoginDTO? get loginDTO => _loginDTO;
  ImageProvider get userImage => _userImage;
  String get userId => _user?.userId ?? "";
  bool get isLogin => _user != null;

  Future<void> loadUser() async {
    final response = await _storage.read(key: 'loginDTO');
    if (response != null) {
      _loginDTO = LoginDTO.fromJson(jsonDecode(response));
      await login(_loginDTO!);
    }
    notifyListeners();
  }

  Future<void> login(LoginDTO loginDTO) async {
    try {
      final response = await http.post(Uri.parse('${Server.userUrl}/login'), headers: Server.header, body: jsonEncode(loginDTO.toJson()));
      final decoded = jsonDecode(response.body);

      if (response.statusCode == 200) {
        final ApiResponse<User> apiResponse = ApiResponse.fromJson(
          decoded,
          (json) => User.fromJson(json as Map<String, dynamic>),
        );

        print("로그인 성공: ${apiResponse.data!.userId}");

        final User user = apiResponse.data!;

        _user = user;
        _loginDTO = loginDTO;
        _userImage = ImageConverter.getImageDecode(user.image);
        await _storage.write(key: 'loginDTO', value: jsonEncode(_loginDTO!.toJson()));
        notifyListeners();

        final messageProvider = getIt<MessageProvider>();
        await messageProvider.loadMessages(user.userId);
      } else {
        await logout();
        print("로그인 실패");
        Show.snackbar("로그인 실패");
      }
    } catch (e) {
      await logout();
      print("❌ 로그인 중 오류 발생: $e");
      Show.snackbar("로그인 중 오류 발생");
    }
    notifyListeners();
  }

  Future<void> logout() async {
    final messageProvider = getIt<MessageProvider>();
    messageProvider.clearAllMessages();

    WebSocketService.disconnectAll();

    _user = null;
    await _storage.delete(key: 'loginDTO');
    notifyListeners();

    print("로그아웃 성공");
  }
}
