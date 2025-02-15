import 'dart:convert';
import 'package:buck_tanley_app/models/Message.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/html.dart';

class WebSocketService {
  // 사용자별 WebSocket 인스턴스를 관리할 싱글톤 Map
  static final Map<String, WebSocketService> _instances = {};

  late WebSocketChannel _channel;
  late Stream<dynamic> _broadcastStream;
  final String userId;

  // private 생성자 (생성 시 WebSocket 연결)
  WebSocketService._create(this.userId) {
    _connect();
  }

  // 싱글톤 인스턴스 반환
  static WebSocketService getInstance(String userId) {
    return _instances.putIfAbsent(userId, () => WebSocketService._create(userId));
  }

  // WebSocket 연결
  void _connect() {
    try {
      _channel = HtmlWebSocketChannel.connect(Uri.parse('ws://localhost:8080/chat?userId=$userId'));
      _broadcastStream = _channel.stream.asBroadcastStream();
      print('🔌 WebSocket 연결 성공: $userId');
    } catch (e) {
      print('🚨 WebSocket 연결 실패: $e');
    }
  }

  // 메시지 전송 (JSON 직렬화)
  void sendMessage(Message message) {
    final jsonString = jsonEncode(message.toJson());
    _channel.sink.add(jsonString);
    print('💬 메시지 전송 ($userId): $jsonString');
  }

  // 메시지 수신 스트림
  Stream<dynamic> get messages => _broadcastStream;

  // WebSocket 연결 해제 및 인스턴스 제거
  void disconnect() {
    _channel.sink.close();
    _instances.remove(userId);
    print('🔌 WebSocket 연결 해제: $userId');
  }
}