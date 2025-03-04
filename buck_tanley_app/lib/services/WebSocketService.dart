import 'dart:convert';

import 'package:buck_tanley_app/core/Import.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:buck_tanley_app/services/WebSocketServiceMobile.dart' if (dart.library.html) 'package:buck_tanley_app/services/WebSocketServiceWeb.dart';

class WebSocketService {
  // 사용자별 WebSocket 인스턴스를 관리할 싱글톤 Map
  static final Map<String, WebSocketService> _instances = {};
  late WebSocketChannel _channel;
  late Stream<dynamic> _broadcastStream;
  final String userId = getIt<UserProvider>().userId;
  final String platform = Server.platform;
  final String type;

  // private 생성자
  WebSocketService._create(this.type) {
    _connect();
  }

  // 싱글톤 인스턴스 반환
  static WebSocketService getInstance(String type) {
    return _instances.putIfAbsent(type, () => WebSocketService._create(type));
  }

  // WebSocket 연결
  void _connect() async {
    try {
      String url = Server.wsUrl(type);
      _channel = WebSocketServiceFactory.connect(url);
      _broadcastStream = _channel.stream.asBroadcastStream();
      print('🔌 WebSocket $type $platform 연결 성공: $userId');
    } catch (e) {
      print('🚨 WebSocket $type $platform 연결 실패: $userId -> $e');
    }
  }

  // WebSocket 메시지 스트림
  Stream<dynamic> get messages => _broadcastStream;

  // 메시지 전송 (JSON 직렬화)
  void sendMessage(Map<String, dynamic> json) {
    final jsonString = jsonEncode(json);
    _channel.sink.add(jsonString);
    print('💬 WebSocket $type $platform 메세지 전송: $userId');
  }

  // WebSocket 연결 해제
  void disconnect() {
    if (_channel.closeCode == null) _channel.sink.close();
    _instances.remove(type);
    print('🔌 WebSocket $type $platform 연결 해제: $userId');
  }

  // WebSocket 연결 해제 (모든 인스턴스)
  static void disconnectAll() {
    _instances.forEach((key, value) {
      if (value._channel.closeCode == null) value._channel.sink.close();
    });
    _instances.clear();
    print('🔌 모든 WebSocket 연결 해제');
  }
}
