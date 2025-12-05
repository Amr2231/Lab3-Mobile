import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

/// Location Service
/// 
/// Handles GPS location and geocoding

class LocationService {
  /// Check if location services are enabled
  static Future<bool> isLocationServiceEnabled() async {
    return await Geolocator.isLocationServiceEnabled();
  }
  
  /// Check location permission
  static Future<LocationPermission> checkPermission() async {
    return await Geolocator.checkPermission();
  }
  
  /// Request location permission
  static Future<LocationPermission> requestPermission() async {
    return await Geolocator.requestPermission();
  }
  
  /// Get current position
  static Future<Position> getCurrentPosition() async {
    // Check if location services are enabled
    bool serviceEnabled = await isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw LocationException('Location services are disabled.');
    }
    
    // Check permission
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
    
    // Get position
    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
  }
  
  /// Get city name from coordinates
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
  
  /// Get current location coordinates and city name
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

/// Custom Exception for Location errors
class LocationException implements Exception {
  final String message;
  
  LocationException(this.message);
  
  @override
  String toString() => message;
}