import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/html.dart';

class WebSocketServiceFactory {
  // 🌐 웹 환경
  static WebSocketChannel connect(String url) {
    return HtmlWebSocketChannel.connect(url);
  }
}
