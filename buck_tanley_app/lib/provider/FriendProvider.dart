import 'package:buck_tanley_app/core/Import.dart';

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

      _friends.sort((a, b) {
        if (a.status == b.status) {
          return a.nickname.compareTo(b.nickname);
        }

        if (a.status == 0) {
          return 1;
        } else {
          return a.status.compareTo(b.status);
        }
      });
    } catch (e) {
      print('친구 목록 로딩 실패: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  UserDTO? getFriend(String userId) {
    for (UserDTO friend in _friends) {
      if (friend.userId == userId) {
        return friend;
      }
    }

    return null;
  }
}
