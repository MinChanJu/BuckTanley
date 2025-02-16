import 'package:buck_tanley_app/models/ApiResponse.dart';
import 'package:buck_tanley_app/utils/Room.dart';
import 'package:buck_tanley_app/utils/Server.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:buck_tanley_app/models/Message.dart';

class MessageProvider with ChangeNotifier {
  // roomId -> List<Message>
  final Map<String, List<Message>> _roomMessages = {};

  Future<void> loadMessages(String userId) async {
    try {
      final response = await http.get(Uri.parse('${Server.url}/messages/$userId'), headers: {
        'Accept': 'application/json; charset=UTF-8',
        'Content-Type': 'application/json; charset=UTF-8',
      });

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        final ApiResponse<List<Message>> messages = ApiResponse.fromJsonList<Message>(
          decoded,
          (json) => Message.fromJson(json),
        );

        if (messages.data != null) {
          for (Message message in messages.data!) {
            String roomId = Room().getRoomId(message.sender, message.receiver);
            _roomMessages.putIfAbsent(roomId, () => []).add(message);
          }
        }
        notifyListeners();
        print('✅ 메시지 초기화 성공 (유저: $userId)');
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

  String getlastForRoom(String roomId) {
    List<Message> messages = _roomMessages[roomId] ?? [];
    if (messages.isEmpty) return "";
    return messages[messages.length - 1].content;
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
    notifyListeners();
  }
}
