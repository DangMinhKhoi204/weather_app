import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

import '../services/location_service.dart';

class LocationProvider extends ChangeNotifier {
  final LocationService _service;

  LocationProvider(this._service);

  Position? position;
  String? cityName;
  bool loading = false;
  String? error;

  Future<void> resolveCurrentLocation() async {
    loading = true;
    error = null;
    notifyListeners();

    try {
      position = await _service.getCurrentPosition();
      cityName = await _service.getCityFromCoords(
        position!.latitude,
        position!.longitude,
      );
    } catch (e) {
      error = e.toString();
    }

    loading = false;
    notifyListeners();
  }
}
