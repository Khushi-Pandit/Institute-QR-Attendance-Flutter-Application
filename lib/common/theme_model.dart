import 'package:flutter/material.dart';

class ThemeModel with ChangeNotifier{ // we are using with to do mixing of ThemeModel and ChangeNotifier -- and changeNotifier will keep track of its listeners.
  bool _isDarkMode = false;
  bool get isDarkMode => _isDarkMode;
  void toggleTheme(){
    _isDarkMode = ! _isDarkMode;
    notifyListeners();
    _saveThemePreference();
  }

  Future <void> _saveThemePreference() async{
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('isDarkMode', _isDarkMode);
  }

  Future <void> loadThemePreference() async{
    final prefs = await SharedPreferences.getInstance();
    _isDarkMode = prefs.getBool('isDarkMode') ?? false;
    notifyListeners();
  }
}