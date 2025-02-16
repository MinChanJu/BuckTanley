class Room {
  String getRoomId(String userId1, String userId2) {
    List<String> users = [userId1, userId2];
    users.sort((a, b) => a.compareTo(b));
    return '${users[0]}_${users[1]}';
  }
}