import 'package:flutter/material.dart';

/// App Constants

class AppConstants {
  // App Info
  static const String appName = 'Weather App';
  static const String appVersion = '1.0.0';
  
  // Storage Keys
  static const String favoriteCitiesKey = 'favorite_cities';
  static const String temperatureUnitKey = 'temperature_unit';
  static const String lastSearchedCityKey = 'last_searched_city';
  
  // Temperature Units
  static const String metric = 'metric'; // Celsius
  static const String imperial = 'imperial'; // Fahrenheit
  
  // Default Values
  static const String defaultCity = 'London';
  static const String defaultUnit = metric;
}

/// App Colors
class AppColors {
  // Primary Colors
  static const Color primary = Color(0xFF2196F3);
  static const Color primaryDark = Color(0xFF1976D2);
  static const Color accent = Color(0xFF03A9F4);
  
  // Background Colors
  static const Color background = Color(0xFFF5F5F5);
  static const Color cardBackground = Colors.white;
  
  // Text Colors
  static const Color textPrimary = Color(0xFF212121);
  static const Color textSecondary = Color(0xFF757575);
  static const Color textLight = Colors.white;
  
  // Weather Condition Colors
  static const Color sunny = Color(0xFFFFB300);
  static const Color cloudy = Color(0xFF78909C);
  static const Color rainy = Color(0xFF42A5F5);
  static const Color snowy = Color(0xFFE1F5FE);
  
  // Status Colors
  static const Color success = Color(0xFF4CAF50);
  static const Color error = Color(0xFFF44336);
  static const Color warning = Color(0xFFFF9800);
  
  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF2196F3), Color(0xFF64B5F6)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const LinearGradient sunnyGradient = LinearGradient(
    colors: [Color(0xFFFFD54F), Color(0xFFFFB300)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const LinearGradient cloudyGradient = LinearGradient(
    colors: [Color(0xFF90A4AE), Color(0xFF607D8B)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const LinearGradient rainyGradient = LinearGradient(
    colors: [Color(0xFF42A5F5), Color(0xFF1976D2)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}

/// Text Styles
class AppTextStyles {
  static const TextStyle heading1 = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
  );
  
  static const TextStyle heading2 = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
  );
  
  static const TextStyle heading3 = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );
  
  static const TextStyle body = TextStyle(
    fontSize: 16,
    color: AppColors.textPrimary,
  );
  
  static const TextStyle bodySecondary = TextStyle(
    fontSize: 16,
    color: AppColors.textSecondary,
  );
  
  static const TextStyle caption = TextStyle(
    fontSize: 14,
    color: AppColors.textSecondary,
  );
  
  static const TextStyle temperature = TextStyle(
    fontSize: 64,
    fontWeight: FontWeight.bold,
    color: AppColors.textLight,
  );
}