import 'package:flutter/material.dart';
import '../models/weather_model.dart';
import '../services/weather_api_service.dart';
import '../services/location_service.dart';
import '../services/storage_service.dart';

/// Weather Provider
/// 
/// Manages weather data and API calls

class WeatherProvider with ChangeNotifier {
  final WeatherApiService _apiService = WeatherApiService();
  
  WeatherModel? _currentWeather;
  bool _isLoading = false;
  String? _error;
  String _temperatureUnit = 'metric';
  
  WeatherModel? get currentWeather => _currentWeather;
  bool get isLoading => _isLoading;
  String? get error => _error;
  String get temperatureUnit => _temperatureUnit;
  bool get hasWeather => _currentWeather != null;
  
  /// Set temperature unit
  void setTemperatureUnit(String unit) {
    _temperatureUnit = unit;
    notifyListeners();
  }
  
  /// Fetch weather by city name
  Future<void> fetchWeatherByCity(String city) async {
    if (city.trim().isEmpty) {
      _error = 'Please enter a city name';
      notifyListeners();
      return;
    }
    
    _isLoading = true;
    _error = null;
    notifyListeners();
    
    try {
      _currentWeather = await _apiService.getWeatherByCity(
        city,
        units: _temperatureUnit,
      );
      _error = null;
      
      // Save as last searched city
      await StorageService.saveLastSearchedCity(city);
    } catch (e) {
      _error = e.toString();
      _currentWeather = null;
    }
    
    _isLoading = false;
    notifyListeners();
  }
  
  /// Fetch weather by coordinates
  Future<void> fetchWeatherByCoordinates(double lat, double lon) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    
    try {
      _currentWeather = await _apiService.getWeatherByCoordinates(
        lat,
        lon,
        units: _temperatureUnit,
      );
      _error = null;
    } catch (e) {
      _error = e.toString();
      _currentWeather = null;
    }
    
    _isLoading = false;
    notifyListeners();
  }
  
  /// Fetch weather for current location
  Future<void> fetchWeatherByCurrentLocation() async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    
    try {
      final locationInfo = await LocationService.getCurrentLocationInfo();
      await fetchWeatherByCoordinates(
        locationInfo['latitude'],
        locationInfo['longitude'],
      );
    } catch (e) {
      _error = e.toString();
      _currentWeather = null;
      _isLoading = false;
      notifyListeners();
    }
  }
  
  /// Refresh current weather
  Future<void> refreshWeather() async {
    if (_currentWeather != null) {
      await fetchWeatherByCity(_currentWeather!.cityName);
    }
  }
  
  /// Clear weather data
  void clearWeather() {
    _currentWeather = null;
    _error = null;
    notifyListeners();
  }
  
  /// Clear error
  void clearError() {
    _error = null;
    notifyListeners();
  }
  
  /// Load last searched city
  Future<void> loadLastSearchedCity() async {
    try {
      final lastCity = await StorageService.getLastSearchedCity();
      if (lastCity != null && lastCity.isNotEmpty) {
        await fetchWeatherByCity(lastCity);
      }
    } catch (e) {
      print('Error loading last searched city: $e');
    }
  }
}