import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class LocationService {
  Future<bool> _ensurePermission() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return false;

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      return false;
    }
    return true;
  }

  Future<Position> getCurrentPosition() async {
    final ok = await _ensurePermission();
    if (!ok) {
      throw Exception('Quyền truy cập vị trí bị từ chối');
    }
    return Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
  }

  Future<String> getCityFromCoords(double lat, double lon) async {
    final placemarks = await placemarkFromCoordinates(lat, lon);
    if (placemarks.isEmpty) return 'Unknown';
    final place = placemarks.first;
    return place.locality ?? place.subAdministrativeArea ?? 'Unknown';
  }
}
