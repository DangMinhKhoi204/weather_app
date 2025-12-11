
class WeatherAlertModel {
  final String event;
  final String description;
  final DateTime start;
  final DateTime end;

  WeatherAlertModel({
    required this.event,
    required this.description,
    required this.start,
    required this.end,
  });

  factory WeatherAlertModel.fromJson(Map<String, dynamic> json) {
    return WeatherAlertModel(
      event: json['event'],
      description: json['description'],
      start: DateTime.fromMillisecondsSinceEpoch(json['start'] * 1000),
      end: DateTime.fromMillisecondsSinceEpoch(json['end'] * 1000),
    );
  }
}
