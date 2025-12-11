class ForecastModel {
  final DateTime time;
  final double temp;
  final double minTemp;
  final double maxTemp;
  final String description;
  final String iconCode;
  final int humidity;
  final double windSpeed;

  ForecastModel({
    required this.time,
    required this.temp,
    required this.minTemp,
    required this.maxTemp,
    required this.description,
    required this.iconCode,
    required this.humidity,
    required this.windSpeed,
  });

  factory ForecastModel.fromJson(Map<String, dynamic> json) {
    return ForecastModel(
      time: DateTime.fromMillisecondsSinceEpoch((json['dt'] ?? 0) * 1000),
      temp: (json['main']?['temp'] ?? 0).toDouble(),
      minTemp: (json['main']?['temp_min'] ?? 0).toDouble(),
      maxTemp: (json['main']?['temp_max'] ?? 0).toDouble(),
      description: json['weather']?[0]?['description'] ?? '',
      iconCode: json['weather']?[0]?['icon'] ?? '01d',
      humidity: json['main']?['humidity'] ?? 0,
      windSpeed: (json['wind']?['speed'] ?? 0).toDouble(),
    );
  }
}
