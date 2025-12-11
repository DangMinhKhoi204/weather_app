import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/settings_provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        children: [
          SwitchListTile(
            title: const Text('Dark mode'),
            value: settings.isDarkMode,
            onChanged: (_) => settings.toggleTheme(),
          ),
          SwitchListTile(
            title: const Text('Use Fahrenheit'),
            value: settings.useFahrenheit,
            onChanged: (_) => settings.toggleUnit(),
          ),
        ],
      ),
    );
  }
}
