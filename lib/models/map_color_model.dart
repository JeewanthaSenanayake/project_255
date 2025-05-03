import 'package:flutter/material.dart';

class MapColorModel with ChangeNotifier {
  dynamic _data = null;
  int _colorVersinPre = 0;
  int _colorVersinNew = 0;

  dynamic get data => _data;
  int get colorVersionPre => _colorVersinPre;
  int get colorVersionNew => _colorVersinNew;

  void setMapColors(dynamic data) {
    _data = data;
    notifyListeners();
  }

  void matchColorVersion() {
    _colorVersinPre = _colorVersinNew;
  }

  void updateColorVersion() {
    _colorVersinNew++;
  }
}
