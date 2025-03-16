import 'package:flutter/material.dart';

class MapColorModel with ChangeNotifier {
  dynamic _data = null;

  dynamic get data => _data;

  void setMapColors(dynamic data) {
    _data = data;
  }
}
