import 'package:flutter/material.dart';
import '../shared/theme/app_theme.dart';

class ThemeProvider with ChangeNotifier {
  ThemeData _themeData = AppTheme.dark;
  bool _isDarkMode = true;

  ThemeData get themeData => _themeData;
  bool get isDarkMode => _isDarkMode;

  void toggleTheme() {
    _themeData =
        _themeData.brightness == Brightness.dark
            ? AppTheme.light
            : AppTheme.dark;
    _isDarkMode = _themeData.brightness == Brightness.dark ? true : false;
    notifyListeners();
  }
}
