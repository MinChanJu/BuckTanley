import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/html.dart';

class MatchWebSocketService {
  // 사용자별 WebSocket 인스턴스를 관리할 싱글톤 Map
  static final Map<String, MatchWebSocketService> _instances = {};
  late WebSocketChannel _channel;
  late Stream<dynamic> _broadcastStream;
  final String userId;

  // private 생성자
  MatchWebSocketService._create(this.userId) {
    _connect();
  }

  // 싱글톤 인스턴스 반환
  static MatchWebSocketService getInstance(String userId) {
    return _instances.putIfAbsent(userId, () => MatchWebSocketService._create(userId));
  }

  // WebSocket 연결
  void _connect() {
    try {
      _channel = HtmlWebSocketChannel.connect(Uri.parse('ws://localhost:8080/match?userId=$userId'));
      _broadcastStream = _channel.stream.asBroadcastStream();
      print('🔌 MatchWebSocket 연결 성공: $userId');
    } catch (e) {
      print('🚨 MatchWebSocket 연결 실패: $e');
    }
  }

  // WebSocket 메시지 스트림
  Stream<dynamic> get messages => _broadcastStream;

  // WebSocket 연결 해제
  void disconnect() {
    _channel.sink.close();
    _instances.remove(userId);
    print('🔌 MatchWebSocket 연결 해제: $userId');
  }
}