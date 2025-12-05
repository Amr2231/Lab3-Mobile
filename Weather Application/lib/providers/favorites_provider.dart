import 'package:flutter/material.dart';
import '../models/city_model.dart';
import '../services/storage_service.dart';



class FavoritesProvider with ChangeNotifier {
  List<CityModel> _favorites = [];
  bool _isLoading = false;
  
  List<CityModel> get favorites => _favorites;
  bool get isLoading => _isLoading;
  bool get hasFavorites => _favorites.isNotEmpty;
  int get favoritesCount => _favorites.length;
  
  Future<void> loadFavorites() async {
    _isLoading = true;
    notifyListeners();
    
    try {
      _favorites = await StorageService.getFavoriteCities();
    } catch (e) {
      print('Error loading favorites: $e');
      _favorites = [];
    }
    
    _isLoading = false;
    notifyListeners();
  }
  
  bool isFavorite(String cityName, String country) {
    return _favorites.any((city) =>
        city.name.toLowerCase() == cityName.toLowerCase() &&
        city.country.toLowerCase() == country.toLowerCase());
  }
  
  Future<bool> addFavorite(String cityName, String country) async {
    // Check if already exists
    if (isFavorite(cityName, country)) {
      return false;
    }
    
    final city = CityModel(name: cityName, country: country);
    
    try {
      final success = await StorageService.addFavoriteCity(city);
      
      if (success) {
        _favorites.add(city);
        notifyListeners();
        return true;
      }
      
      return false;
    } catch (e) {
      print('Error adding favorite: $e');
      return false;
    }
  }
  
  Future<bool> removeFavorite(String cityName, String country) async {
    final city = _favorites.firstWhere(
      (c) =>
          c.name.toLowerCase() == cityName.toLowerCase() &&
          c.country.toLowerCase() == country.toLowerCase(),
      orElse: () => CityModel(name: '', country: ''),
    );
    
    if (city.name.isEmpty) {
      return false;
    }
    
    try {
      final success = await StorageService.removeFavoriteCity(city);
      
      if (success) {
        _favorites.removeWhere((c) => c == city);
        notifyListeners();
        return true;
      }
      
      return false;
    } catch (e) {
      print('Error removing favorite: $e');
      return false;
    }
  }
  
  Future<bool> toggleFavorite(String cityName, String country) async {
    if (isFavorite(cityName, country)) {
      return await removeFavorite(cityName, country);
    } else {
      return await addFavorite(cityName, country);
    }
  }
  
  Future<void> clearAllFavorites() async {
    try {
      await StorageService.clearFavorites();
      _favorites.clear();
      notifyListeners();
    } catch (e) {
      print('Error clearing favorites: $e');
    }
  }
  
  List<String> getFavoriteCityNames() {
    return _favorites.map((city) => city.name).toList();
  }
}