import 'package:flutter/material.dart';

import '../models/weather_model.dart';

class WeatherDetailsSection extends StatelessWidget {
  final WeatherModel weather;

  const WeatherDetailsSection({super.key, required this.weather});

  @override
  Widget build(BuildContext context) {
    final items = [
      _DetailItem(label: 'Humidity', value: '${weather.humidity}%'),
      _DetailItem(label: 'Wind', value: '${weather.windSpeed} m/s'),
      _DetailItem(label: 'Pressure', value: '${weather.pressure} hPa'),
      if (weather.visibility != null)
        _DetailItem(label: 'Visibility', value: '${weather.visibility! / 1000} km'),
      if (weather.cloudiness != null)
        _DetailItem(label: 'Cloudiness', value: '${weather.cloudiness}%'),
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Wrap(
            spacing: 16,
            runSpacing: 12,
            children: items.map((e) {
              return SizedBox(
                width: MediaQuery.of(context).size.width / 2 - 32,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      e.label,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      e.value,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}

class _DetailItem {
  final String label;
  final String value;

  _DetailItem({required this.label, required this.value});
}
