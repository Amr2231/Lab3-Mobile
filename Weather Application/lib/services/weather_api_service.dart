import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/api_config.dart';
import '../models/weather_model.dart';

/// Weather API Service
/// 
/// Handles all API calls to OpenWeatherMap

class WeatherApiService {
  /// Fetch weather data by city name
  Future<WeatherModel> getWeatherByCity(
    String city, {
    String units = 'metric',
  }) async {
    try {
      final url = ApiConfig.getWeatherByCityUrl(city, units);
      final response = await http.get(Uri.parse(url));
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return WeatherModel.fromJson(data);
      } else if (response.statusCode == 404) {
        throw WeatherException('City not found. Please check the city name.');
      } else if (response.statusCode == 401) {
        throw WeatherException('Invalid API key. Please check your configuration.');
      } else {
        throw WeatherException('Failed to fetch weather data: ${response.statusCode}');
      }
    } catch (e) {
      if (e is WeatherException) {
        rethrow;
      }
      throw WeatherException('Network error: ${e.toString()}');
    }
  }
  
  /// Fetch weather data by coordinates
  Future<WeatherModel> getWeatherByCoordinates(
    double lat,
    double lon, {
    String units = 'metric',
  }) async {
    try {
      final url = ApiConfig.getWeatherByCoordinatesUrl(lat, lon, units);
      final response = await http.get(Uri.parse(url));
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return WeatherModel.fromJson(data);
      } else if (response.statusCode == 401) {
        throw WeatherException('Invalid API key. Please check your configuration.');
      } else {
        throw WeatherException('Failed to fetch weather data: ${response.statusCode}');
      }
    } catch (e) {
      if (e is WeatherException) {
        rethrow;
      }
      throw WeatherException('Network error: ${e.toString()}');
    }
  }
  
  /// Fetch weather for multiple cities
  Future<List<WeatherModel>> getWeatherForCities(
    List<String> cities, {
    String units = 'metric',
  }) async {
    final weatherList = <WeatherModel>[];
    
    for (final city in cities) {
      try {
        final weather = await getWeatherByCity(city, units: units);
        weatherList.add(weather);
      } catch (e) {
        // Skip cities that fail to load
        print('Failed to load weather for $city: $e');
      }
    }
    
    return weatherList;
  }
}

/// Custom Exception for Weather API errors
class WeatherException implements Exception {
  final String message;
  
  WeatherException(this.message);
  
  @override
  String toString() => message;
}