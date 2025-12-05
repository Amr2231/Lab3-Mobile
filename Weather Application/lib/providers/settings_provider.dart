import 'package:flutter/material.dart';
import '../services/storage_service.dart';
import '../utils/constants.dart';



class SettingsProvider with ChangeNotifier {
  String _temperatureUnit = AppConstants.defaultUnit;
  bool _isLoading = false;
  
  String get temperatureUnit => _temperatureUnit;
  bool get isLoading => _isLoading;
  bool get isMetric => _temperatureUnit == AppConstants.metric;
  bool get isImperial => _temperatureUnit == AppConstants.imperial;
  
  String get unitSymbol => isMetric ? '°C' : '°F';
  String get unitName => isMetric ? 'Celsius' : 'Fahrenheit';
  
  Future<void> loadSettings() async {
    _isLoading = true;
    notifyListeners();
    
    try {
      _temperatureUnit = await StorageService.getTemperatureUnit();
    } catch (e) {
      print('Error loading settings: $e');
      _temperatureUnit = AppConstants.defaultUnit;
    }
    
    _isLoading = false;
    notifyListeners();
  }
  
  Future<void> setTemperatureUnit(String unit) async {
    if (unit != AppConstants.metric && unit != AppConstants.imperial) {
      return;
    }
    
    _temperatureUnit = unit;
    notifyListeners();
    
    try {
      await StorageService.saveTemperatureUnit(unit);
    } catch (e) {
      print('Error saving temperature unit: $e');
    }
  }
  
  Future<void> toggleTemperatureUnit() async {
    final newUnit = isMetric ? AppConstants.imperial : AppConstants.metric;
    await setTemperatureUnit(newUnit);
  }
  
  double convertTemperature(double celsius) {
    if (isImperial) {
      return (celsius * 9 / 5) + 32;
    }
    return celsius;
  }
  
  Future<void> resetSettings() async {
    await setTemperatureUnit(AppConstants.defaultUnit);
  }
}