import 'package:flutter/foundation.dart';

class UserProvider with ChangeNotifier {
  String? _authToken;

  String? get authToken => _authToken;

  bool get isLoggedIn => _authToken != null;

  void login(String token) {
    _authToken = token;
    notifyListeners();
  }

  void logout() {
    _authToken = null;
    notifyListeners();
  }
}
