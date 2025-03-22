import 'package:flutter/material.dart';

class UserModel with ChangeNotifier {
  dynamic _data = null;
  String _userId = "";

  dynamic get data => _data;
  String get userId => _userId;

  void updateUser(String key, dynamic value) {
    if (_data.containsKey(key)) {
      _data[key] = value;
      notifyListeners(); // Notify widgets of the update
    }
  }

  void setUserId(String uid) {
    _userId = uid;
  }

  void createUser(dynamic data) {
    _data = data;
  }
}
