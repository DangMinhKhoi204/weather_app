import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/weather_provider.dart';
import '../widgets/daily_forecast_section.dart';

class ForecastScreen extends StatelessWidget {
  const ForecastScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final forecast = context.watch<WeatherProvider>().forecast;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Forecast'),
      ),
      body: DailyForecastSection(forecast: forecast),
    );
  }
}
