import 'dart:convert';
import 'package:http/http.dart' as http;

import '../config/api_config.dart';
import '../models/weather_model.dart';
import '../models/forecast_model.dart';

class WeatherService {
  const WeatherService();

  Future<WeatherModel> fetchCurrentByCity(String city) async {
    final url = ApiConfig.currentByCity(city);
    final res = await http.get(Uri.parse(url));

    if (res.statusCode == 404) {
      throw Exception('Không tìm thấy thành phố "$city"');
    }

    if (res.statusCode != 200) {
      throw Exception('Không thể tải dữ liệu thời tiết (mã ${res.statusCode})');
    }

    final data = jsonDecode(res.body) as Map<String, dynamic>;
    return WeatherModel.fromJson(data);
  }

  Future<WeatherModel> fetchCurrentByCoords(double lat, double lon) async {
    final url = ApiConfig.currentByCoords(lat, lon);
    final res = await http.get(Uri.parse(url));

    if (res.statusCode != 200) {
      throw Exception('Không thể tải thời tiết theo vị trí hiện tại');
    }

    final data = jsonDecode(res.body) as Map<String, dynamic>;
    return WeatherModel.fromJson(data);
  }

  Future<List<ForecastModel>> fetchForecastByCity(String city) async {
    final url = ApiConfig.forecastByCity(city);
    final res = await http.get(Uri.parse(url));

    if (res.statusCode != 200) {
      throw Exception('Không thể tải dự báo thời tiết');
    }

    final decoded = jsonDecode(res.body) as Map<String, dynamic>;
    final list = (decoded['list'] as List<dynamic>? ?? []);
    return list
        .map((e) => ForecastModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  String iconUrl(String iconCode) {
    return 'https://openweathermap.org/img/wn/$iconCode@2x.png';
  }
}
