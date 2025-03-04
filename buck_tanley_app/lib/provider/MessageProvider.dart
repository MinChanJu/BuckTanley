import 'dart:convert';

import 'package:buck_tanley_app/SetUp.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class MessageProvider with ChangeNotifier {
  // roomId -> List<Message>
  final Map<String, List<Message>> _roomMessages = {};
  WebSocketService? wsService;

  Future<void> loadMessages(String userId) async {
    try {
      final response = await http.get(Uri.parse('${Server.apiUrl}/messages/$userId'), headers: Server.header);

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        final ApiResponse<List<Message>> messages = ApiResponse.fromJsonList<Message>(
          decoded,
          (json) => Message.fromJson(json),
        );

        if (messages.data != null) {
          for (Message message in messages.data!) {
            String roomId = Room.getRoomId(message.sender, message.receiver);
            _roomMessages.putIfAbsent(roomId, () => []).add(message);
          }
        }
        notifyListeners();
        print('✅ 메시지 불러오기 성공 (유저: $userId)');
        wsService = WebSocketService.getInstance(Server.type(1));
        wsService!.messages.listen((data) {
          try {
            final message = Message.fromJson(jsonDecode(data));
            String roomId = Room.getRoomId(message.sender, message.receiver);
            addMessage(roomId, message);
            print('📨 type: ${wsService!.type}, platform: ${wsService!.platform} userId: ${wsService!.userId}, 메시지 수신 및 저장 (방: $roomId): ${message.content}');
          } catch (e) {
            print('❌ type: ${wsService!.type}, platform: ${wsService!.platform} userId: ${wsService!.userId}, 메시지 파싱 실패: $e');
          }
        }, onDone: () {
          print('🔌 type: ${wsService!.type}, platform: ${wsService!.platform} userId: ${wsService!.userId}, WebSocket 연결 종료');
        }, onError: (error) {
          print('❌ type: ${wsService!.type}, platform: ${wsService!.platform} userId: ${wsService!.userId}, WebSocket 오류: $error');
        });
      } else {
        print('❌ 서버 응답 오류: ${response.statusCode}');
      }
    } catch (e) {
      print('⚠️ 메시지 가져오기 실패: $e');
    }
  }

  // 특정 방의 메시지 리스트 조회
  List<Message> getMessagesForRoom(String roomId) {
    return _roomMessages[roomId] ?? [];
  }

  Message? getLastForRoom(String roomId) {
    List<Message> messages = _roomMessages[roomId] ?? [];
    if (messages.isEmpty) return null;
    return messages[messages.length - 1];
  }

  // 특정 방에 메시지 추가
  void addMessage(String roomId, Message message) {
    _roomMessages.putIfAbsent(roomId, () => []).add(message);
    notifyListeners();
  }

  // 특정 방에 다수 메시지 추가
  void addMessages(String roomId, List<Message> messages) {
    _roomMessages.putIfAbsent(roomId, () => []).addAll(messages);
    notifyListeners();
  }

  // 특정 방 메시지 초기화
  void clearMessagesForRoom(String roomId) {
    _roomMessages[roomId]?.clear();
    notifyListeners();
  }

  // 모든 메시지 초기화
  void clearAllMessages() {
    _roomMessages.clear();
    wsService?.disconnect();
    notifyListeners();
    print("모든 메세지 초기화");
  }
}
