import 'package:flutter/material.dart';

class UserModel with ChangeNotifier {
  dynamic _data = null;

  dynamic get data => _data;

  void updateUser(String key, dynamic value) {
    if (_data.containsKey(key)) {
      _data[key] = value;
      notifyListeners(); // Notify widgets of the update
    }
  }

  void createUser(dynamic data) {
    _data = data;
  }
}
