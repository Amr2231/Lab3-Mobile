import 'package:intl/intl.dart';


class WeatherHelpers {
  static String formatTime(int timestamp, int timezoneOffset) {
    final date = DateTime.fromMillisecondsSinceEpoch(
      (timestamp + timezoneOffset) * 1000,
      isUtc: true,
    );
    return DateFormat('HH:mm').format(date);
  }

  static String formatDate(int timestamp) {
    final date = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
    return DateFormat('EEEE, MMM d').format(date);
  }
  
  static String getCurrentLocalTime(int timezoneOffset) {
    final now = DateTime.now().toUtc();
    final localTime = now.add(Duration(seconds: timezoneOffset));
    return DateFormat('HH:mm:ss').format(localTime);
  }
  
  static String getFullDateTime(int timestamp, int timezoneOffset) {
    final date = DateTime.fromMillisecondsSinceEpoch(
      (timestamp + timezoneOffset) * 1000,
      isUtc: true,
    );
    return DateFormat('MMM d, yyyy - HH:mm').format(date);
  }
  
  static String formatWindSpeed(double speedMs) {
    final speedKmh = speedMs * 3.6;
    return '${speedKmh.toStringAsFixed(1)} km/h';
  }
  
  static String formatVisibility(int visibilityMeters) {
    final visibilityKm = visibilityMeters / 1000;
    return '${visibilityKm.toStringAsFixed(1)} km';
  }
  
  static String getWeatherEmoji(String condition) {
    switch (condition.toLowerCase()) {
      case 'clear':
        return '☀️';
      case 'clouds':
        return '☁️';
      case 'rain':
      case 'drizzle':
        return '🌧️';
      case 'thunderstorm':
        return '⛈️';
      case 'snow':
        return '❄️';
      case 'mist':
      case 'fog':
      case 'haze':
        return '🌫️';
      default:
        return '🌤️';
    }
  }
  
  static String capitalizeWords(String text) {
    return text
        .split(' ')
        .map((word) => word.isEmpty
            ? word
            : word[0].toUpperCase() + word.substring(1).toLowerCase())
        .join(' ');
  }
  
  static String formatTemperature(double temp, String unit) {
    final symbol = unit == 'metric' ? '°C' : '°F';
    return '${temp.round()}$symbol';
  }
  
  static bool isValidCityName(String city) {
    return city.trim().isNotEmpty && city.length >= 2;
  }
}