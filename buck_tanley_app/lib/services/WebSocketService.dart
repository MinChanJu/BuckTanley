import 'dart:convert';

import 'package:buck_tanley_app/SetUp.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/html.dart';

class WebSocketService {
  // 사용자별 WebSocket 인스턴스를 관리할 싱글톤 Map
  static final Map<String, WebSocketService> _instances = {};
  late WebSocketChannel _channel;
  late Stream<dynamic> _broadcastStream;
  final String userId;
  final String type;

  // private 생성자
  WebSocketService._create(this.userId, this.type) {
    _connect();
  }

  // 싱글톤 인스턴스 반환
  static WebSocketService getInstance(String userId, String type) {
    return _instances.putIfAbsent(type, () => WebSocketService._create(userId, type));
  }

  // WebSocket 연결
  void _connect() {
    try {
      String url = "";
      if (type == "chat" || type == "random") url = Server.chatWS;
      if (type == "match") url = Server.matchWS;
      _channel = HtmlWebSocketChannel.connect(Uri.parse('$url?userId=$userId&type=$type'));
      _broadcastStream = _channel.stream.asBroadcastStream();
      print('🔌 WebSocket $type 연결 성공: $userId');
    } catch (e) {
      print('🚨 WebSocket $type 연결 실패: $e');
    }
  }

  // WebSocket 메시지 스트림
  Stream<dynamic> get messages => _broadcastStream;

  // 메시지 전송 (JSON 직렬화)
  void sendMessage(Map<String, dynamic> json) {
    final jsonString = jsonEncode(json);
    _channel.sink.add(jsonString);
    print('💬 WebSocket $type 메세지 전송: $userId');
  }

  // WebSocket 연결 해제
  void disconnect() {
    _channel.sink.close();
    _instances.remove(type);
    print('🔌 WebSocket $type 연결 해제: $userId');
  }
}