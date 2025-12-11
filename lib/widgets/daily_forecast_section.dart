import 'package:flutter/material.dart';

import '../models/forecast_model.dart';
import '../utils/date_formatter.dart';

class DailyForecastSection extends StatelessWidget {
  final List<ForecastModel> forecast;

  const DailyForecastSection({super.key, required this.forecast});

  @override
  Widget build(BuildContext context) {
    if (forecast.isEmpty) return const SizedBox.shrink();

    // group theo ngày
    final Map<DateTime, List<ForecastModel>> byDay = {};
    for (final f in forecast) {
      final key = DateTime(f.time.year, f.time.month, f.time.day);
      byDay.putIfAbsent(key, () => []).add(f);
    }

    final days = byDay.keys.toList()..sort((a, b) => a.compareTo(b));

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            children: const [
              Text(
                '5-day forecast',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ...days.take(5).map((day) {
            final items = byDay[day]!;
            final minTemp = items.map((e) => e.minTemp).reduce((a, b) => a < b ? a : b);
            final maxTemp = items.map((e) => e.maxTemp).reduce((a, b) => a > b ? a : b);
            final desc = items[items.length ~/ 2].description;

            return ListTile(
              dense: true,
              contentPadding: const EdgeInsets.symmetric(horizontal: 0),
              title: Text(DateFormatter.dayName(day)),
              subtitle: Text(desc),
              trailing: Text(
                '${minTemp.round()}° / ${maxTemp.round()}°',
                style: const TextStyle(fontWeight: FontWeight.w500),
              ),
            );
          }),
        ],
      ),
    );
  }
}
