class Room {
  static String getRoomId(String userId1, String userId2) {
    List<String> users = [userId1, userId2];
    users.sort((a, b) => a.compareTo(b));
    String roomId = '${users[0]}_${users[1]}';
    return roomId;
  }

  static List<String> getUserByRoomId(String roomId) {
    List<String> users = roomId.split('_');
    return users;
  }
}