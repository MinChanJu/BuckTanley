import 'dart:convert';

import 'package:buck_tanley_app/SetUp.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class UserProvider with ChangeNotifier {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  User? _user;
  LoginDTO? _loginDTO;

  User? get user => _user;
  LoginDTO? get loginDTO => _loginDTO;
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
        await _storage.write(key: 'loginDTO', value: jsonEncode(_loginDTO!.toJson()));
        notifyListeners();

        final messageProvider = getIt<MessageProvider>();
        await messageProvider.loadMessages(user.userId);

        final wsService = WebSocketService.getInstance("chat");
        wsService.messages.listen((data) {
          try {
            final message = Message.fromJson(jsonDecode(data));
            String roomId = Room.getRoomId(message.sender, message.receiver);
            messageProvider.addMessage(roomId, message);
            print('📨 메시지 수신 및 저장 (방: $roomId): ${message.content}');
          } catch (e) {
            print('❌ 메시지 파싱 실패: $e');
          }
        }, onDone: () {
          print('🔌 WebSocket 연결 종료');
        }, onError: (error) {
          print('❌ WebSocket 오류: $error');
        });
      } else {
        await logout();
        print("로그인 실패");
        Snack.showSnackbar("로그인 실패");
      }
    } catch (e) {
      await logout();
      print("❌ 로그인 중 오류 발생: $e");
      Snack.showSnackbar("로그인 중 오류 발생");
    }
    notifyListeners();
  }

  Future<void> logout() async {
    final messageProvider = getIt<MessageProvider>();
    messageProvider.clearAllMessages();

    final wsService = WebSocketService.getInstance("chat");
    wsService.disconnect();

    _user = null;
    await _storage.delete(key: 'loginDTO');
    notifyListeners();
  }
}
