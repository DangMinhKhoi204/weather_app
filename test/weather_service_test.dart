import 'package:flutter_test/flutter_test.dart';
import 'package:weather_app/models/weather_model.dart';

void main() {
  group("WeatherModel JSON Parsing", () {
    test("Parses valid weather JSON correctly", () {
      final sampleJson = {
        "coord": {"lon": 106.0, "lat": 10.0},
        "weather": [
          {"id": 800, "main": "Clear", "description": "clear sky", "icon": "01d"}
        ],
        "main": {
          "temp": 25.0,
          "feels_like": 26.0,
          "temp_min": 24.0,
          "temp_max": 27.0,
          "pressure": 1010,
          "humidity": 80
        },
        "visibility": 10000,
        "wind": {"speed": 2.0},
        "clouds": {"all": 1},
        "dt": 1234567890,
        "sys": {"country": "VN"},
        "name": "Ho Chi Minh City"
      };

      final weather = WeatherModel.fromJson(sampleJson);

      expect(weather.city, "Ho Chi Minh City");
      expect(weather.temp, 25.0);
      expect(weather.country, "VN");
      expect(weather.description, "clear sky");
      expect(weather.iconCode, "01d");
    });
  });
}
