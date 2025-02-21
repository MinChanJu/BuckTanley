import 'dart:convert';

import 'package:buck_tanley_app/models/entity/Message.dart';
import 'package:buck_tanley_app/provider/MessageProvider.dart';
import 'package:buck_tanley_app/services/WebSocketService.dart';
import 'package:buck_tanley_app/utils/Room.dart';
import 'package:buck_tanley_app/utils/Server.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class UserProvider with ChangeNotifier {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  String? _token;

  String? get token => _token;
  bool get isLogin => _token != null;

  Future<void> loadUser() async {
    _token = await _storage.read(key: 'accessToken');
    if (_token != null) {
      await _validateToken();
    } else {
      notifyListeners();
    }
  }

  Future<void> _validateToken() async {
    final url = Uri.parse('${Server.userUrl}/validateToken');
    final headers = {'Authorization': 'Bearer $token', ...Server.header};

    try {
      final response = await http.get(url, headers: headers);
      if (response.statusCode == 200) {
        notifyListeners();
      } else {
        await logout();
      }
    } catch (e) {
      print("❌ 자동 로그인 실패: $e");
      await logout();
    }
  }

  Future<void> login(String token) async {
    _token = token;
    await _storage.write(key: 'accessToken', value: _token);
    notifyListeners();

    final wsService = WebSocketService.getInstance(token, "chat");
    final messageProvider = MessageProvider();
    messageProvider.loadMessages(token);

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
  }

  Future<void> logout() async {
    final wsService = WebSocketService.getInstance(_token ?? "", "chat");
    wsService.disconnect();

    _token = null;
    await _storage.delete(key: 'token');
    notifyListeners();
  }
}
