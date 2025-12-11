import 'package:flutter/material.dart';
import 'weather_map_screen.dart';

class WeatherMapMenu extends StatelessWidget {
  const WeatherMapMenu({super.key});

  @override
  Widget build(BuildContext context) {
    // Thứ tự phải trùng với map trong WeatherMapScreen
    final options = [
      "Clouds",
      "Temperature",
      "Precipitation",
      "Wind",
    ];

    return Scaffold(
      appBar: AppBar(title: const Text("Weather Map")),
      body: ListView.builder(
        itemCount: options.length,
        itemBuilder: (context, index) {
          final title = options[index];
          return ListTile(
            title: Text(title),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  // 👉 Truyền index, KHÔNG truyền 'layer:' nữa
                  builder: (_) => WeatherMapScreen(initialIndex: index),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
