import 'package:buck_tanley_app/services/ChatWebSocketService.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class UserProvider with ChangeNotifier {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  String? _token;

  String? get token => _token;
  bool get isLogin => _token != null;

  Future<void> loadUser() async {
    _token = await _storage.read(key: 'token');
    notifyListeners();
  }

  Future<void> login(String token) async {
    _token = token;
    await _storage.write(key: 'token', value: _token);
    notifyListeners();
  }

  Future<void> logout() async {
    final wsService = ChatWebSocketService.getInstance(_token ?? "");
    wsService.disconnect();

    _token = null;
    await _storage.delete(key: 'token');
    notifyListeners();
  }
}