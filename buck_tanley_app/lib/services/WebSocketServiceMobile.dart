import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/io.dart';

class WebSocketServiceFactory {
  // 💻 데스크톱 및 모바일 환경
  static WebSocketChannel connect(String url) {
    return IOWebSocketChannel.connect(url);
  }
}