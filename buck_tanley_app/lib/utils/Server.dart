class Server {
  static const String baseUrl = "http://localhost:8080";
  
  static const String apiUrl = "http://localhost:8080/api";

  static const String userUrl = "http://localhost:8080/api/users";
  static const String messageUrl = "http://localhost:8080/api/messages";
  static const String friendUrl = "http://localhost:8080/api/friends";

  static const String chatWS = "ws://localhost:8080/chat";
  static const String matchWS = "ws://localhost:8080/match";

  static const Map<String, String> header = {
    'Accept': 'application/json; charset=UTF-8',
    'Content-Type': 'application/json; charset=UTF-8',
  };
}
