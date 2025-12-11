import 'package:flutter/material.dart';

import '../models/forecast_model.dart';
import '../utils/date_formatter.dart';

class HourlyForecastList extends StatelessWidget {
  final List<ForecastModel> items;

  const HourlyForecastList({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return const SizedBox.shrink();
    }

    final firstDay = items.first.time.day;
    final hourly = items.where((e) => e.time.day == firstDay).toList();

    return SizedBox(
      height: 120,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        scrollDirection: Axis.horizontal,
        itemCount: hourly.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final h = hourly[index];
          return Container(
            width: 80,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface.withOpacity(0.9),
              borderRadius: BorderRadius.circular(18),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(DateFormatter.hour(h.time),
                    style: const TextStyle(fontSize: 12)),
                Text('${h.temp.round()}°',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    )),
                Text(
                  h.description,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 10),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
