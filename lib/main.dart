import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

void main() {
  runApp(const FlightProgressApp());
}

class FlightProgressApp extends StatelessWidget {
  const FlightProgressApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flight Progress',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF0A0E21),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF00D4FF),
          secondary: Color(0xFFFF6B35),
        ),
      ),
      home: const FlightProgressScreen(),
    );
  }
}

class City {
  final String name;
  final String country;
  final double lat;
  final double lon;
  final String emoji;

  const City({
    required this.name,
    required this.country,
    required this.lat,
    required this.lon,
    required this.emoji,
  });

  String get displayName => '$emoji $name, $country';
}

const List<City> capitals = [
  // Europe
  City(name: 'Berlin', country: 'Germany', lat: 52.5200, lon: 13.4050, emoji: '🇩🇪'),
  City(name: 'London', country: 'UK', lat: 51.5074, lon: -0.1278, emoji: '🇬🇧'),
  City(name: 'Paris', country: 'France', lat: 48.8566, lon: 2.3522, emoji: '🇫🇷'),
  City(name: 'Madrid', country: 'Spain', lat: 40.4168, lon: -3.7038, emoji: '🇪🇸'),
  City(name: 'Rome', country: 'Italy', lat: 41.9028, lon: 12.4964, emoji: '🇮🇹'),
  City(name: 'Vienna', country: 'Austria', lat: 48.2082, lon: 16.3738, emoji: '🇦🇹'),
  City(name: 'Amsterdam', country: 'Netherlands', lat: 52.3676, lon: 4.9041, emoji: '🇳🇱'),
  City(name: 'Warsaw', country: 'Poland', lat: 52.2297, lon: 21.0122, emoji: '🇵🇱'),
  City(name: 'Moscow', country: 'Russia', lat: 55.7558, lon: 37.6173, emoji: '🇷🇺'),
  City(name: 'Stockholm', country: 'Sweden', lat: 59.3293, lon: 18.0686, emoji: '🇸🇪'),
  City(name: 'Oslo', country: 'Norway', lat: 59.9139, lon: 10.7522, emoji: '🇳🇴'),
  City(name: 'Copenhagen', country: 'Denmark', lat: 55.6761, lon: 12.5683, emoji: '🇩🇰'),
  City(name: 'Helsinki', country: 'Finland', lat: 60.1699, lon: 24.9384, emoji: '🇫🇮'),
  City(name: 'Lisbon', country: 'Portugal', lat: 38.7223, lon: -9.1393, emoji: '🇵🇹'),
  City(name: 'Athens', country: 'Greece', lat: 37.9838, lon: 23.7275, emoji: '🇬🇷'),
  City(name: 'Prague', country: 'Czech Republic', lat: 50.0755, lon: 14.4378, emoji: '🇨🇿'),
  City(name: 'Budapest', country: 'Hungary', lat: 47.4979, lon: 19.0402, emoji: '🇭🇺'),
  City(name: 'Zurich', country: 'Switzerland', lat: 47.3769, lon: 8.5417, emoji: '🇨🇭'),
  
  // Americas
  City(name: 'New York', country: 'USA', lat: 40.7128, lon: -74.0060, emoji: '🇺🇸'),
  City(name: 'Washington D.C.', country: 'USA', lat: 38.9072, lon: -77.0369, emoji: '🇺🇸'),
  City(name: 'Los Angeles', country: 'USA', lat: 34.0522, lon: -118.2437, emoji: '🇺🇸'),
  City(name: 'Miami', country: 'USA', lat: 25.7617, lon: -80.1918, emoji: '🇺🇸'),
  City(name: 'Toronto', country: 'Canada', lat: 43.6532, lon: -79.3832, emoji: '🇨🇦'),
  City(name: 'Mexico City', country: 'Mexico', lat: 19.4326, lon: -99.1332, emoji: '🇲🇽'),
  City(name: 'São Paulo', country: 'Brazil', lat: -23.5505, lon: -46.6333, emoji: '🇧🇷'),
  City(name: 'Buenos Aires', country: 'Argentina', lat: -34.6037, lon: -58.3816, emoji: '🇦🇷'),
  
  // Asia
  City(name: 'Tokyo', country: 'Japan', lat: 35.6762, lon: 139.6503, emoji: '🇯🇵'),
  City(name: 'Beijing', country: 'China', lat: 39.9042, lon: 116.4074, emoji: '🇨🇳'),
  City(name: 'Shanghai', country: 'China', lat: 31.2304, lon: 121.4737, emoji: '🇨🇳'),
  City(name: 'Hong Kong', country: 'China', lat: 22.3193, lon: 114.1694, emoji: '🇭🇰'),
  City(name: 'Singapore', country: 'Singapore', lat: 1.3521, lon: 103.8198, emoji: '🇸🇬'),
  City(name: 'Bangkok', country: 'Thailand', lat: 13.7563, lon: 100.5018, emoji: '🇹🇭'),
  City(name: 'Seoul', country: 'South Korea', lat: 37.5665, lon: 126.9780, emoji: '🇰🇷'),
  City(name: 'Delhi', country: 'India', lat: 28.6139, lon: 77.2090, emoji: '🇮🇳'),
  City(name: 'Mumbai', country: 'India', lat: 19.0760, lon: 72.8777, emoji: '🇮🇳'),
  City(name: 'Dubai', country: 'UAE', lat: 25.2048, lon: 55.2708, emoji: '🇦🇪'),
  City(name: 'Tel Aviv', country: 'Israel', lat: 32.0853, lon: 34.7818, emoji: '🇮🇱'),
  City(name: 'Istanbul', country: 'Turkey', lat: 41.0082, lon: 28.9784, emoji: '🇹🇷'),
  
  // Africa & Oceania
  City(name: 'Cairo', country: 'Egypt', lat: 30.0444, lon: 31.2357, emoji: '🇪🇬'),
  City(name: 'Cape Town', country: 'South Africa', lat: -33.9249, lon: 18.4241, emoji: '🇿🇦'),
  City(name: 'Sydney', country: 'Australia', lat: -33.8688, lon: 151.2093, emoji: '🇦🇺'),
  City(name: 'Melbourne', country: 'Australia', lat: -37.8136, lon: 144.9631, emoji: '🇦🇺'),
  City(name: 'Auckland', country: 'New Zealand', lat: -36.8509, lon: 174.7645, emoji: '🇳🇿'),
];

class FlightProgressScreen extends StatefulWidget {
  const FlightProgressScreen({super.key});

  @override
  State<FlightProgressScreen> createState() => _FlightProgressScreenState();
}

class _FlightProgressScreenState extends State<FlightProgressScreen> {
  City? departure;
  City? destination;
  Position? currentPosition;
  Position? startPosition;
  double? totalDistance;
  double? remainingDistance;
  double progress = 0.0;
  bool isTracking = false;
  bool hasLocationPermission = false;
  String statusMessage = 'Wähle Start und Ziel';
  Timer? updateTimer;
  StreamSubscription<Position>? positionStream;

  @override
  void initState() {
    super.initState();
    _checkPermissions();
  }

  @override
  void dispose() {
    updateTimer?.cancel();
    positionStream?.cancel();
    super.dispose();
  }

  Future<void> _checkPermissions() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      setState(() => statusMessage = 'GPS ist deaktiviert');
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.denied || 
        permission == LocationPermission.deniedForever) {
      setState(() => statusMessage = 'GPS-Berechtigung erforderlich');
      return;
    }

    setState(() {
      hasLocationPermission = true;
      statusMessage = 'Wähle Start und Ziel';
    });
  }

  double _calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    const double earthRadius = 6371; // km
    double dLat = _toRadians(lat2 - lat1);
    double dLon = _toRadians(lon2 - lon1);
    double a = sin(dLat / 2) * sin(dLat / 2) +
        cos(_toRadians(lat1)) * cos(_toRadians(lat2)) *
        sin(dLon / 2) * sin(dLon / 2);
    double c = 2 * atan2(sqrt(a), sqrt(1 - a));
    return earthRadius * c;
  }

  double _toRadians(double degrees) => degrees * pi / 180;

  void _startTracking() async {
    if (destination == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Bitte wähle ein Ziel')),
      );
      return;
    }

    try {
      Position position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
        ),
      );

      setState(() {
        startPosition = position;
        currentPosition = position;
        totalDistance = _calculateDistance(
          position.latitude,
          position.longitude,
          destination!.lat,
          destination!.lon,
        );
        remainingDistance = totalDistance;
        progress = 0.0;
        isTracking = true;
        statusMessage = 'Tracking aktiv...';
      });

      // Start position stream
      positionStream = Geolocator.getPositionStream(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          distanceFilter: 100, // Update every 100m
        ),
      ).listen(_updatePosition);

      // Also use timer for periodic updates
      updateTimer = Timer.periodic(const Duration(seconds: 10), (_) {
        _fetchPosition();
      });

    } catch (e) {
      setState(() => statusMessage = 'GPS-Fehler: $e');
    }
  }

  void _fetchPosition() async {
    if (!isTracking) return;
    try {
      Position position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
        ),
      );
      _updatePosition(position);
    } catch (e) {
      // Ignore errors during periodic fetch
    }
  }

  void _updatePosition(Position position) {
    if (!isTracking || destination == null || totalDistance == null) return;

    double newRemainingDistance = _calculateDistance(
      position.latitude,
      position.longitude,
      destination!.lat,
      destination!.lon,
    );

    double newProgress = 1.0 - (newRemainingDistance / totalDistance!);
    newProgress = newProgress.clamp(0.0, 1.0);

    setState(() {
      currentPosition = position;
      remainingDistance = newRemainingDistance;
      progress = newProgress;
      
      if (newRemainingDistance < 50) {
        statusMessage = '🎉 Angekommen!';
        _stopTracking();
      } else {
        statusMessage = 'Tracking aktiv...';
      }
    });
  }

  void _stopTracking() {
    updateTimer?.cancel();
    positionStream?.cancel();
    setState(() {
      isTracking = false;
      statusMessage = 'Tracking gestoppt';
    });
  }

  void _reset() {
    _stopTracking();
    setState(() {
      departure = null;
      destination = null;
      currentPosition = null;
      startPosition = null;
      totalDistance = null;
      remainingDistance = null;
      progress = 0.0;
      statusMessage = 'Wähle Start und Ziel';
    });
  }

  void _setDepartureFromCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
        ),
      );
      setState(() {
        startPosition = position;
        statusMessage = 'Startposition gesetzt';
      });
      
      if (destination != null) {
        setState(() {
          totalDistance = _calculateDistance(
            position.latitude,
            position.longitude,
            destination!.lat,
            destination!.lon,
          );
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('GPS-Fehler: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    _buildProgressCard(),
                    const SizedBox(height: 24),
                    _buildDestinationSelector(),
                    const SizedBox(height: 24),
                    _buildInfoCards(),
                    const SizedBox(height: 24),
                    _buildControls(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFF1A1F3C),
            const Color(0xFF0A0E21).withOpacity(0.8),
          ],
        ),
      ),
      child: Row(
        children: [
          const Text(
            '✈️',
            style: TextStyle(fontSize: 32),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Flight Progress',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Text(
                  'GPS-basierter Fortschritt',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: isTracking ? Colors.green : Colors.grey,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              isTracking ? 'LIVE' : 'IDLE',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressCard() {
    int progressPercent = (progress * 100).round();
    
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF1A1F3C), Color(0xFF2D325A)],
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF00D4FF).withOpacity(0.2),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            '$progressPercent%',
            style: const TextStyle(
              fontSize: 72,
              fontWeight: FontWeight.bold,
              color: Color(0xFF00D4FF),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            statusMessage,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[400],
            ),
          ),
          const SizedBox(height: 24),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 20,
              backgroundColor: const Color(0xFF0A0E21),
              valueColor: AlwaysStoppedAnimation<Color>(
                progress < 0.5
                    ? const Color(0xFF00D4FF)
                    : progress < 0.8
                        ? const Color(0xFF00FF88)
                        : const Color(0xFFFFD700),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                startPosition != null ? '📍 Start' : '📍 --',
                style: const TextStyle(color: Colors.grey),
              ),
              if (destination != null)
                Text(
                  '🎯 ${destination!.name}',
                  style: const TextStyle(color: Colors.grey),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDestinationSelector() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1F3C),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Ziel auswählen',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<City>(
            value: destination,
            decoration: InputDecoration(
              filled: true,
              fillColor: const Color(0xFF0A0E21),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              prefixIcon: const Icon(Icons.flight_land, color: Color(0xFF00D4FF)),
            ),
            dropdownColor: const Color(0xFF1A1F3C),
            hint: const Text('Zielstadt wählen'),
            isExpanded: true,
            items: capitals.map((city) {
              return DropdownMenuItem(
                value: city,
                child: Text(city.displayName),
              );
            }).toList(),
            onChanged: isTracking ? null : (city) {
              setState(() {
                destination = city;
                if (startPosition != null && city != null) {
                  totalDistance = _calculateDistance(
                    startPosition!.latitude,
                    startPosition!.longitude,
                    city.lat,
                    city.lon,
                  );
                  remainingDistance = totalDistance;
                }
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCards() {
    return Row(
      children: [
        Expanded(
          child: _buildInfoCard(
            'Gesamt',
            totalDistance != null ? '${totalDistance!.round()} km' : '-- km',
            Icons.straighten,
            const Color(0xFF00D4FF),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildInfoCard(
            'Verbleibend',
            remainingDistance != null ? '${remainingDistance!.round()} km' : '-- km',
            Icons.flight,
            const Color(0xFFFF6B35),
          ),
        ),
      ],
    );
  }

  Widget _buildInfoCard(String label, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1F3C),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildControls() {
    return Column(
      children: [
        if (!isTracking) ...[
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: hasLocationPermission ? _setDepartureFromCurrentLocation : null,
              icon: const Icon(Icons.my_location),
              label: const Text('Aktuelle Position als Start'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2D325A),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: hasLocationPermission && destination != null
                  ? _startTracking
                  : null,
              icon: const Icon(Icons.play_arrow),
              label: const Text('Tracking starten'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF00D4FF),
                foregroundColor: const Color(0xFF0A0E21),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ] else ...[
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: _stopTracking,
              icon: const Icon(Icons.stop),
              label: const Text('Tracking stoppen'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFF6B35),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ],
        const SizedBox(height: 12),
        TextButton.icon(
          onPressed: _reset,
          icon: const Icon(Icons.refresh),
          label: const Text('Zurücksetzen'),
          style: TextButton.styleFrom(
            foregroundColor: Colors.grey,
          ),
        ),
      ],
    );
  }
}
