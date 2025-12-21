import 'package:flutter/material.dart';

class Settings extends ChangeNotifier {
  double _fontScale = 1.0;
  bool _isDarkMode = false;

  double get fontScale => _fontScale;
  bool get isDarkMode => _isDarkMode;

  // 개별 변경
  void setDarkMode(bool value) {
    _isDarkMode = value;
    notifyListeners(); // 값이 바뀔 때마다 테마가 다시 그려짐
  }

  void setFontScale(double value) {
    _fontScale = value;
    notifyListeners();
  }
}
