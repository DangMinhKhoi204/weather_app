import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/weather_model.dart';
import '../services/weather_service.dart';
import '../utils/constants.dart';

class CurrentWeatherCard extends StatelessWidget {
  final WeatherModel weather;
  final WeatherService service;

  const CurrentWeatherCard({
    super.key,
    required this.weather,
    required this.service,
  });

  LinearGradient _gradientForCondition(String condition, bool isNight) {
    final cond = condition.toLowerCase();
    if (isNight) {
      return const LinearGradient(
        colors: [AppColors.nightTop, AppColors.nightBottom],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      );
    }
    if (cond.contains('rain')) {
      return const LinearGradient(
        colors: [AppColors.rainyTop, AppColors.rainyBottom],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      );
    }
    if (cond.contains('cloud')) {
      return const LinearGradient(
        colors: [AppColors.cloudyTop, AppColors.cloudyBottom],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      );
    }
    return const LinearGradient(
      colors: [AppColors.sunnyTop, AppColors.sunnyBottom],
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
    );
  }

  @override
  Widget build(BuildContext context) {
    final isNight = weather.iconCode.endsWith('n');

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      decoration: BoxDecoration(
        gradient: _gradientForCondition(weather.main, isNight),
        borderRadius: BorderRadius.circular(24),
        boxShadow: const [
          BoxShadow(
            blurRadius: 16,
            color: Colors.black26,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            '${weather.city}, ${weather.country}',
            style: const TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            DateFormat('EEEE, dd MMMM').format(weather.time),
            style: const TextStyle(color: Colors.white70),
          ),
          const SizedBox(height: 16),
          CachedNetworkImage(
            imageUrl: service.iconUrl(weather.iconCode),
            height: 100,
          ),
          const SizedBox(height: 8),
          Text(
            '${weather.temp.round()}°',
            style: const TextStyle(
              fontSize: 72,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          Text(
            weather.description.toUpperCase(),
            style: const TextStyle(
              color: Colors.white,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Feels like ${weather.feelsLike.round()}°',
            style: const TextStyle(color: Colors.white70),
          ),
        ],
      ),
    );
  }
}
