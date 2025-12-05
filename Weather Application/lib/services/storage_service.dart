import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/city_model.dart';
import '../utils/constants.dart';

/// Local Storage Service
/// 
/// Handles persistent storage using SharedPreferences

class StorageService {
  static SharedPreferences? _prefs;
  
  /// Initialize SharedPreferences
  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }
  
  /// Ensure preferences are initialized
  static Future<SharedPreferences> _getPrefs() async {
    if (_prefs == null) {
      await init();
    }
    return _prefs!;
  }
  
  // ========== FAVORITE CITIES ==========
  
  /// Save favorite cities
  static Future<bool> saveFavoriteCities(List<CityModel> cities) async {
    final prefs = await _getPrefs();
    final citiesJson = cities.map((city) => city.toJson()).toList();
    final citiesString = json.encode(citiesJson);
    return await prefs.setString(AppConstants.favoriteCitiesKey, citiesString);
  }
  
  /// Get favorite cities
  static Future<List<CityModel>> getFavoriteCities() async {
    final prefs = await _getPrefs();
    final citiesString = prefs.getString(AppConstants.favoriteCitiesKey);
    
    if (citiesString == null || citiesString.isEmpty) {
      return [];
    }
    
    try {
      final List<dynamic> citiesJson = json.decode(citiesString);
      return citiesJson
          .map((json) => CityModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print('Error loading favorite cities: $e');
      return [];
    }
  }
  
  /// Add city to favorites
  static Future<bool> addFavoriteCity(CityModel city) async {
    final cities = await getFavoriteCities();
    
    // Check if city already exists
    if (cities.any((c) => c == city)) {
      return false;
    }
    
    cities.add(city);
    return await saveFavoriteCities(cities);
  }
  
  /// Remove city from favorites
  static Future<bool> removeFavoriteCity(CityModel city) async {
    final cities = await getFavoriteCities();
    cities.removeWhere((c) => c == city);
    return await saveFavoriteCities(cities);
  }
  
  /// Check if city is in favorites
  static Future<bool> isFavorite(String cityName, String country) async {
    final cities = await getFavoriteCities();
    return cities.any((c) =>
        c.name.toLowerCase() == cityName.toLowerCase() &&
        c.country.toLowerCase() == country.toLowerCase());
  }
  
  // ========== SETTINGS ==========
  
  /// Save temperature unit
  static Future<bool> saveTemperatureUnit(String unit) async {
    final prefs = await _getPrefs();
    return await prefs.setString(AppConstants.temperatureUnitKey, unit);
  }
  
  /// Get temperature unit
  static Future<String> getTemperatureUnit() async {
    final prefs = await _getPrefs();
    return prefs.getString(AppConstants.temperatureUnitKey) ??
        AppConstants.defaultUnit;
  }
  
  // ========== SEARCH HISTORY ==========
  
  /// Save last searched city
  static Future<bool> saveLastSearchedCity(String city) async {
    final prefs = await _getPrefs();
    return await prefs.setString(AppConstants.lastSearchedCityKey, city);
  }
  
  /// Get last searched city
  static Future<String?> getLastSearchedCity() async {
    final prefs = await _getPrefs();
    return prefs.getString(AppConstants.lastSearchedCityKey);
  }
  
  // ========== CLEAR DATA ==========
  
  /// Clear all data
  static Future<bool> clearAllData() async {
    final prefs = await _getPrefs();
    return await prefs.clear();
  }
  
  /// Clear favorites only
  static Future<bool> clearFavorites() async {
    final prefs = await _getPrefs();
    return await prefs.remove(AppConstants.favoriteCitiesKey);
  }
}