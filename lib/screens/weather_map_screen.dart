import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:geolocator/geolocator.dart';

class WeatherMapScreen extends StatefulWidget {
  final int initialIndex; // 👈 nhận index layer từ menu

  const WeatherMapScreen({
    super.key,
    this.initialIndex = 0,
  });

  @override
  State<WeatherMapScreen> createState() => _WeatherMapScreenState();
}

class _WeatherMapScreenState extends State<WeatherMapScreen> {
  late String apiKey;

  final Map<String, String> layers = {
    "Clouds": "clouds",
    "Temp": "temp",
    "Rain": "precipitation",
    "Wind": "wind",
  };

  late int currentIndex;
  double opacityValue = 0.6;
  double zoom = 5.0;
  LatLng? currentLocation;

  final MapController mapController = MapController();

  @override
  void initState() {
    super.initState();
    apiKey = dotenv.env['OPENWEATHER_API_KEY'] ?? "";
    currentIndex = widget.initialIndex; // 👈 set layer ban đầu theo menu
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    bool enabled = await Geolocator.isLocationServiceEnabled();
    if (!enabled) return;

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.deniedForever ||
        permission == LocationPermission.denied) {
      return;
    }

    final pos = await Geolocator.getCurrentPosition();
    setState(() {
      currentLocation = LatLng(pos.latitude, pos.longitude);
      mapController.move(currentLocation!, zoom);
    });
  }

  @override
  Widget build(BuildContext context) {
    final layerKey = layers.values.elementAt(currentIndex);

    final tileUrl =
        "https://tile.openweathermap.org/map/$layerKey/{z}/{x}/{y}.png?appid=$apiKey";

    return Scaffold(
      appBar: AppBar(
        title: Text("Weather Map - ${layers.keys.elementAt(currentIndex)}"),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          FlutterMap(
            mapController: mapController,
            options: MapOptions(
              initialCenter: const LatLng(16.047, 108.206),
              initialZoom: zoom,
              maxZoom: 13,
              minZoom: 3,
            ),
            children: [
              // Nền OSM
              TileLayer(
                urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
                userAgentPackageName: "com.example.weather_app",
              ),
              // Overlay weather
              Opacity(
                opacity: opacityValue,
                child: TileLayer(
                  urlTemplate: tileUrl,
                  userAgentPackageName: "com.example.weather_app",
                ),
              ),
              // Marker vị trí hiện tại
              if (currentLocation != null)
                MarkerLayer(
                  markers: [
                    Marker(
                      point: currentLocation!,
                      width: 40,
                      height: 40,
                      child: const Icon(
                        Icons.location_on,
                        size: 40,
                        color: Colors.red,
                      ),
                    ),
                  ],
                ),
            ],
          ),

          // Tab chọn layer
          Positioned(
            bottom: 150,
            left: 10,
            right: 10,
            child: _buildLayerSelector(context),
          ),

          // Slider opacity
          Positioned(
            bottom: 100,
            left: 20,
            right: 20,
            child: _buildOpacitySlider(),
          ),

          // Nút Zoom
          Positioned(
            right: 15,
            bottom: 210,
            child: Column(
              children: [
                _zoomButton(Icons.add, () {
                  setState(() {
                    zoom += 0.5;
                    mapController.move(mapController.center, zoom);
                  });
                }),
                const SizedBox(height: 10),
                _zoomButton(Icons.remove, () {
                  setState(() {
                    zoom -= 0.5;
                    mapController.move(mapController.center, zoom);
                  });
                }),
              ],
            ),
          ),
        ],
      ),

      // FAB back
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green.shade600,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Icon(Icons.arrow_back, color: Colors.white),
        onPressed: () => Navigator.pop(context),
      ),
    );
  }

  // Nút zoom
  Widget _zoomButton(IconData icon, VoidCallback onTap) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Material(
        color: Colors.blue.shade600,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Icon(icon, color: Colors.white),
          ),
        ),
      ),
    );
  }

  // Slider opacity
  Widget _buildOpacitySlider() {
    return Row(
      children: [
        const Icon(Icons.opacity, size: 20),
        Expanded(
          child: Slider(
            value: opacityValue,
            min: 0.1,
            max: 1.0,
            divisions: 10,
            label: opacityValue.toStringAsFixed(1),
            onChanged: (value) {
              setState(() => opacityValue = value);
            },
          ),
        ),
      ],
    );
  }

  // Selector layer
  Widget _buildLayerSelector(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor.withOpacity(0.9),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            blurRadius: 10,
            color: Colors.black.withOpacity(0.15),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(layers.length, (index) {
          final isActive = index == currentIndex;

          return GestureDetector(
            onTap: () => setState(() => currentIndex = index),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              padding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: isActive ? Colors.blue : Colors.grey.shade200,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                layers.keys.elementAt(index),
                style: TextStyle(
                  color: isActive ? Colors.white : Colors.black87,
                  fontWeight:
                  isActive ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
