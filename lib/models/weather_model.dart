class WeatherModel {
  final String city;
  final String country;
  final double temp;
  final double feelsLike;
  final int humidity;
  final double windSpeed;
  final int pressure;
  final String description;
  final String iconCode;
  final String main;
  final DateTime time;
  final double? minTemp;
  final double? maxTemp;
  final int? visibility;
  final int? cloudiness;

  WeatherModel({
    required this.city,
    required this.country,
    required this.temp,
    required this.feelsLike,
    required this.humidity,
    required this.windSpeed,
    required this.pressure,
    required this.description,
    required this.iconCode,
    required this.main,
    required this.time,
    this.minTemp,
    this.maxTemp,
    this.visibility,
    this.cloudiness,
  });

  factory WeatherModel.fromJson(Map<String, dynamic> json) {
    return WeatherModel(
      city: json['name'] ?? '',
      country: json['sys']?['country'] ?? '',
      temp: (json['main']?['temp'] ?? 0).toDouble(),
      feelsLike: (json['main']?['feels_like'] ?? 0).toDouble(),
      humidity: json['main']?['humidity'] ?? 0,
      windSpeed: (json['wind']?['speed'] ?? 0).toDouble(),
      pressure: json['main']?['pressure'] ?? 0,
      description: json['weather']?[0]?['description'] ?? '',
      iconCode: json['weather']?[0]?['icon'] ?? '01d',
      main: json['weather']?[0]?['main'] ?? '',
      time: DateTime.fromMillisecondsSinceEpoch((json['dt'] ?? 0) * 1000),
      minTemp: json['main']?['temp_min']?.toDouble(),
      maxTemp: json['main']?['temp_max']?.toDouble(),
      visibility: json['visibility'],
      cloudiness: json['clouds']?['all'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': city,
      'sys': {'country': country},
      'main': {
        'temp': temp,
        'feels_like': feelsLike,
        'humidity': humidity,
        'pressure': pressure,
        'temp_min': minTemp,
        'temp_max': maxTemp,
      },
      'wind': {'speed': windSpeed},
      'weather': [
        {
          'description': description,
          'icon': iconCode,
          'main': main,
        }
      ],
      'dt': time.millisecondsSinceEpoch ~/ 1000,
      'visibility': visibility,
      'clouds': {'all': cloudiness},
    };
  }
}
