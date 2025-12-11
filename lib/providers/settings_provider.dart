import 'package:flutter/material.dart';

class SettingsProvider extends ChangeNotifier {
  bool _isDarkMode = false;
  bool _useFahrenheit = false;

  bool get isDarkMode => _isDarkMode;
  bool get useFahrenheit => _useFahrenheit;

  void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    notifyListeners();
  }

  void toggleUnit() {
    _useFahrenheit = !_useFahrenheit;
    notifyListeners();
  }

  String formatTemp(double celsius) {
    if (!_useFahrenheit) return '${celsius.toStringAsFixed(1)}°C';
    final f = celsius * 9 / 5 + 32;
    return '${f.toStringAsFixed(1)}°F';
  }
}
