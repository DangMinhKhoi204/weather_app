import 'package:flutter/material.dart';

import '../models/weather_model.dart';
import '../models/forecast_model.dart';
import '../services/weather_service.dart';
import '../services/location_service.dart';
import '../services/storage_service.dart';
import '../services/connectivity_service.dart';

enum WeatherStatus { idle, loading, ready, error, offlineCached }

class WeatherProvider extends ChangeNotifier {
  final WeatherService weatherService;
  final LocationService locationService;
  final StorageService storageService;
  final ConnectivityService connectivityService;

  WeatherProvider({
    required this.weatherService,
    required this.locationService,
    required this.storageService,
    required this.connectivityService,
  });

  WeatherStatus status = WeatherStatus.idle;
  WeatherModel? current;
  List<ForecastModel> forecast = [];
  String? errorMessage;

  String _currentCity = 'Ho Chi Minh City';

  String get currentCity => _currentCity;

  Future<void> bootstrap() async {
    // thử load cache trước
    final hasCache = await storageService.isCacheValid();
    if (hasCache) {
      final cached = await storageService.readWeather();
      if (cached != null) {
        current = cached;
        status = WeatherStatus.offlineCached;
        notifyListeners();
      }
    }

    await refreshByLocation();
  }

  Future<void> refreshByLocation() async {
    status = WeatherStatus.loading;
    notifyListeners();

    try {
      final hasNet = await connectivityService.hasNetwork();
      if (!hasNet) {
        errorMessage = 'Không có kết nối mạng. Đang hiển thị dữ liệu cũ.';
        status = WeatherStatus.offlineCached;
        notifyListeners();
        return;
      }

      final pos = await locationService.getCurrentPosition();
      final weather = await weatherService.fetchCurrentByCoords(
        pos.latitude,
        pos.longitude,
      );
      _currentCity = weather.city;
      final fc = await weatherService.fetchForecastByCity(_currentCity);

      current = weather;
      forecast = fc;
      await storageService.saveWeather(weather);

      status = WeatherStatus.ready;
      errorMessage = null;
    } catch (e) {
      status = WeatherStatus.error;
      errorMessage = e.toString();
    }

    notifyListeners();
  }

  Future<void> refreshByCity(String city) async {
    status = WeatherStatus.loading;
    notifyListeners();

    try {
      final hasNet = await connectivityService.hasNetwork();
      if (!hasNet) {
        errorMessage = 'Không có kết nối mạng.';
        status = WeatherStatus.offlineCached;
        notifyListeners();
        return;
      }

      final weather = await weatherService.fetchCurrentByCity(city);
      final fc = await weatherService.fetchForecastByCity(city);

      _currentCity = city;
      current = weather;
      forecast = fc;
      await storageService.saveWeather(weather);

      status = WeatherStatus.ready;
      errorMessage = null;
    } catch (e) {
      status = WeatherStatus.error;
      errorMessage = e.toString();
    }

    notifyListeners();
  }
}
