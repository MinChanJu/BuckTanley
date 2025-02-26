class Server {
  static const String baseUrl = "http://localhost:8080";
  
  static const String apiUrl = "http://localhost:8080/api";

  static const String userUrl = "http://localhost:8080/api/users";
  static const String messageUrl = "http://localhost:8080/api/messages";
  static const String friendUrl = "http://localhost:8080/api/friends";

  static String wsUrl(String userId, String type) {
    if (type == "chat" || type == "random") return "ws://localhost:8080/chat?userId=$userId&type=$type";
    if (type == "match") return "ws://localhost:8080/match?userId=$userId&type=$type";
    return "";
  }
  static const String chatWS = "ws://localhost:8080/chat";
  static const String matchWS = "ws://localhost:8080/match";

  static const Map<String, String> header = {
    'Accept': 'application/json; charset=UTF-8',
    'Content-Type': 'application/json; charset=UTF-8',
  };
}
