import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';


class LocationService {
  static Future<bool> isLocationServiceEnabled() async {
    return await Geolocator.isLocationServiceEnabled();
  }
  
  static Future<LocationPermission> checkPermission() async {
    return await Geolocator.checkPermission();
  }
  
  static Future<LocationPermission> requestPermission() async {
    return await Geolocator.requestPermission();
  }
  
  static Future<Position> getCurrentPosition() async {
    bool serviceEnabled = await isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw LocationException('Location services are disabled.');
    }
    
    LocationPermission permission = await checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await requestPermission();
      if (permission == LocationPermission.denied) {
        throw LocationException('Location permission denied.');
      }
    }
    
    if (permission == LocationPermission.deniedForever) {
      throw LocationException(
        'Location permissions are permanently denied. Please enable them in settings.',
      );
    }
    
    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
  }
  
  static Future<String> getCityFromCoordinates(
    double latitude,
    double longitude,
  ) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        latitude,
        longitude,
      );
      
      if (placemarks.isNotEmpty) {
        final place = placemarks.first;
        return place.locality ?? place.administrativeArea ?? 'Unknown';
      }
      
      throw LocationException('Could not determine city name');
    } catch (e) {
      throw LocationException('Geocoding error: ${e.toString()}');
    }
  }
  
  static Future<Map<String, dynamic>> getCurrentLocationInfo() async {
    try {
      final position = await getCurrentPosition();
      final cityName = await getCityFromCoordinates(
        position.latitude,
        position.longitude,
      );
      
      return {
        'latitude': position.latitude,
        'longitude': position.longitude,
        'city': cityName,
      };
    } catch (e) {
      throw LocationException('Failed to get location info: ${e.toString()}');
    }
  }
}

class LocationException implements Exception {
  final String message;
  
  LocationException(this.message);
  
  @override
  String toString() => message;
}