import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiConfig {
  ApiConfig._();

  static const String _root = 'https://api.openweathermap.org/data/2.5';

  static String get _apiKey => dotenv.env['OPENWEATHER_API_KEY'] ?? '';

  static String currentByCity(String city) {
    return _build('/weather', {'q': city});
  }

  static String forecastByCity(String city) {
    return _build('/forecast', {'q': city});
  }

  static String currentByCoords(double lat, double lon) {
    return _build('/weather', {
      'lat': lat.toString(),
      'lon': lon.toString(),
    });
  }

  static String _build(String path, Map<String, String> params) {
    final base = Uri.parse('$_root$path');
    final query = <String, String>{
      ...params,
      'appid': _apiKey,
      'units': 'metric',
    };
    return base.replace(queryParameters: query).toString();
  }
}
