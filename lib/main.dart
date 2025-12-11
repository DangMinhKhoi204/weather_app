import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';

import 'providers/weather_provider.dart';
import 'providers/location_provider.dart';
import 'providers/settings_provider.dart';

import 'screens/home_screen.dart';

import 'services/weather_service.dart';
import 'services/location_service.dart';
import 'services/storage_service.dart';
import 'services/connectivity_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load .env
  await dotenv.load(fileName: '.env');

  // Init services
  final weatherService = WeatherService();
  final locationService = LocationService();
  final storageService = StorageService();
  final connectivityService = ConnectivityService();

  runApp(MyApp(
    weatherService: weatherService,
    locationService: locationService,
    storageService: storageService,
    connectivityService: connectivityService,
  ));
}

class MyApp extends StatelessWidget {
  final WeatherService weatherService;
  final LocationService locationService;
  final StorageService storageService;
  final ConnectivityService connectivityService;

  const MyApp({
    super.key,
    required this.weatherService,
    required this.locationService,
    required this.storageService,
    required this.connectivityService,
  });

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => SettingsProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => LocationProvider(locationService),
        ),
        ChangeNotifierProvider(
          create: (_) => WeatherProvider(
            weatherService: weatherService,
            locationService: locationService,
            storageService: storageService,
            connectivityService: connectivityService,
          )..bootstrap(),
        ),
      ],
      child: Consumer<SettingsProvider>(
        builder: (context, settings, _) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: "Weather Lab 4",
            theme: ThemeData(
              brightness:
              settings.isDarkMode ? Brightness.dark : Brightness.light,
              useMaterial3: true,
              colorSchemeSeed: Colors.blue,
            ),
            home: const HomeScreen(),
          );
        },
      ),
    );
  }
}
