import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/weather_provider.dart';
import '../providers/settings_provider.dart';

import '../widgets/current_weather_card.dart';
import '../widgets/hourly_forecast_list.dart';
import '../widgets/daily_forecast_section.dart';
import '../widgets/weather_details_section.dart';
import '../widgets/loading_shimmer.dart';
import '../widgets/error_widget_custom.dart';

import '../services/weather_service.dart';

import 'search_screen.dart';
import 'settings_screen.dart';
import 'forecast_screen.dart';
import 'weather_map_menu.dart';   // 👈 THÊM IMPORT WEATHER MAP

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final weatherProvider = context.watch<WeatherProvider>();
    final settings = context.watch<SettingsProvider>();
    final status = weatherProvider.status;

    Widget body;

    if (status == WeatherStatus.loading && weatherProvider.current == null) {
      body = const LoadingShimmer();
    } else if ((status == WeatherStatus.error ||
        status == WeatherStatus.offlineCached) &&
        weatherProvider.current == null) {
      body = ErrorWidgetCustom(
        message: weatherProvider.errorMessage ?? 'Đã xảy ra lỗi',
        onRetry: () => weatherProvider.refreshByLocation(),
      );
    } else if (weatherProvider.current == null) {
      body = const Center(child: Text('No weather data'));
    } else {
      body = RefreshIndicator(
        onRefresh: () =>
            weatherProvider.refreshByCity(weatherProvider.currentCity),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              CurrentWeatherCard(
                weather: weatherProvider.current!,
                service: const WeatherService(),
              ),
              const SizedBox(height: 8),

              // Hourly forecast
              HourlyForecastList(items: weatherProvider.forecast),

              // Daily forecast (5 days)
              DailyForecastSection(forecast: weatherProvider.forecast),

              // Details (humidity, wind, pressure…)
              WeatherDetailsSection(weather: weatherProvider.current!),

              const SizedBox(height: 16),

              // ⭐ WEATHER MAP BUTTON ⭐
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 14),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const WeatherMapMenu(),
                      ),
                    );
                  },
                  icon: const Icon(Icons.map, size: 22),
                  label: const Text(
                    "Open Weather Map",
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Weather App - Lab 4'),
        actions: [
          // Theme toggle
          IconButton(
            icon:
            Icon(settings.isDarkMode ? Icons.light_mode : Icons.dark_mode),
            onPressed: settings.toggleTheme,
          ),

          // Settings
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const SettingsScreen()),
              );
            },
          ),
        ],
      ),

      body: body,

      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const SearchScreen()),
        ),
        child: const Icon(Icons.search),
      ),

      // Bottom button — Full Forecast
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: ElevatedButton.icon(
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const ForecastScreen()),
            );
          },
          icon: const Icon(Icons.calendar_today),
          label: const Text('View full forecast'),
        ),
      ),
    );
  }
}
