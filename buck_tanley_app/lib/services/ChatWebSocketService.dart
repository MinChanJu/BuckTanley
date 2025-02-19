import 'dart:convert';
import 'package:buck_tanley_app/models/Message.dart';
import 'package:buck_tanley_app/utils/Room.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/html.dart';

class ChatWebSocketService {
  // 사용자별 WebSocket 인스턴스를 관리할 싱글톤 Map
  static final Map<String, ChatWebSocketService> _instances = {};
  late WebSocketChannel _channel;
  late Stream<dynamic> _broadcastStream;
  final String userId;

  // private 생성자
  ChatWebSocketService._create(this.userId) {
    _connect();
  }

  // 싱글톤 인스턴스 반환
  static ChatWebSocketService getInstance(String userId) {
    return _instances.putIfAbsent(userId, () => ChatWebSocketService._create(userId));
  }

  // WebSocket 연결
  void _connect() {
    try {
      _channel = HtmlWebSocketChannel.connect(Uri.parse('ws://localhost:8080/chat?userId=$userId'));
      _broadcastStream = _channel.stream.asBroadcastStream();
      print('🔌 ChatWebSocket 연결 성공: $userId');
    } catch (e) {
      print('🚨 ChatWebSocket 연결 실패: $e');
    }
  }

  // 메시지 전송 (JSON 직렬화)
  void sendMessage(Message message) {
    final jsonString = jsonEncode(message.toJson());
    _channel.sink.add(jsonString);
    print('💬 메시지 전송 ($userId -> 방: ${Room.getRoomId(message.sender, message.receiver)}): $jsonString');
  }

  // WebSocket 메시지 스트림
  Stream<dynamic> get messages => _broadcastStream;

  // WebSocket 연결 해제
  void disconnect() {
    _channel.sink.close();
    _instances.remove(userId);
    print('🔌 ChatWebSocket 연결 해제: $userId');
  }
}