import 'package:buck_tanley_app/SetUp.dart';

import 'package:flutter/material.dart';

class FriendProvider extends ChangeNotifier {
  final FriendService _friendService = FriendService();
  List<UserDTO> _friends = [];
  bool _isLoading = false;

  List<UserDTO> get friends => _friends;
  bool get isLoading => _isLoading;

  Future<void> loadFriends(String userId) async {
    _isLoading = true;
    notifyListeners();

    try {
      _friends = await _friendService.loadFriends(userId);
      print('친구 목록 불러오기 성공');
    } catch (e) {
      print('친구 목록 로딩 실패: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}