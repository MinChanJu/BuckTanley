class Server {
  static const String url = "http://localhost:8080/api";
  static const String chatWS = "ws://localhost:8080/chat";
  static const String matchWS = "ws://localhost:8080/match";

  static const Map<String, String> header = {
    'Accept': 'application/json; charset=UTF-8',
    'Content-Type': 'application/json; charset=UTF-8',
  };
}
