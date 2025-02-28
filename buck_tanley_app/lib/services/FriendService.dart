import 'dart:convert';
import 'package:buck_tanley_app/SetUp.dart';
import 'package:http/http.dart' as http;

class FriendService {
  Future<List<UserDTO>> loadFriends(String userId) async {
    final response = await http.get(Uri.parse('${Server.apiUrl}/$userId'));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body)['data']; // API 응답에서 데이터 추출
      return data.map((json) => UserDTO.fromJson(json)).toList();
    } else {
      throw Exception('친구 목록을 불러오지 못했습니다.');
    }
  }
}
