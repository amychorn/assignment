import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider with ChangeNotifier {
  ThemeData _currentTheme = ThemeData.light();

  ThemeData get currentTheme => _currentTheme;
  bool get isDarkMode => _currentTheme == ThemeData.dark();

  ThemeProvider() {
    _loadTheme();
  }

  Future<void> _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final isDarkTheme = prefs.getBool('isDarkTheme') ?? false;
    _currentTheme = isDarkTheme ? ThemeData.dark() : ThemeData.light();
    notifyListeners();
  }

  Future<void> toggleTheme() async {
    _currentTheme = _currentTheme == ThemeData.dark()
        ? ThemeData.light()
        : ThemeData.dark();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDarkTheme', _currentTheme == ThemeData.dark());
    notifyListeners();
  }
}
