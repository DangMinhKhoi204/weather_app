import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/weather_model.dart';

class StorageService {
  static const _weatherKey = 'cached_weather';
  static const _lastUpdateKey = 'cached_last_update';
  static const _favoriteCitiesKey = 'favorite_cities';

  Future<void> saveWeather(WeatherModel model) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_weatherKey, jsonEncode(model.toJson()));
    await prefs.setInt(_lastUpdateKey, DateTime.now().millisecondsSinceEpoch);
  }

  Future<WeatherModel?> readWeather() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_weatherKey);
    if (raw == null) return null;
    return WeatherModel.fromJson(jsonDecode(raw));
  }

  Future<bool> isCacheValid({Duration maxAge = const Duration(minutes: 30)}) async {
    final prefs = await SharedPreferences.getInstance();
    final ts = prefs.getInt(_lastUpdateKey);
    if (ts == null) return false;
    final diff = DateTime.now().millisecondsSinceEpoch - ts;
    return diff < maxAge.inMilliseconds;
  }

  Future<List<String>> getFavoriteCities() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_favoriteCitiesKey) ?? <String>[];
  }

  Future<void> saveFavoriteCities(List<String> cities) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_favoriteCitiesKey, cities);
  }
}
