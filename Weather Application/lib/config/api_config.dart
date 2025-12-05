/// API Configuration
/// 
/// IMPORTANT: Add your OpenWeatherMap API key here
/// Get your free API key from: https://openweathermap.org/api
/// 
/// NOTE: In production, use environment variables or secure storage
/// Never commit your API key to public repositories

class ApiConfig {
  // TODO: Replace with your actual API key
  static const String apiKey = 'e1e84edc70e73d6f3cd7f311eca9890d';
  
  // Base URL for OpenWeatherMap API
  static const String baseUrl = 'https://api.openweathermap.org/data/2.5';
  
  // API Endpoints
  static const String weatherEndpoint = '/weather';
  
  // Icon URL
  static String getIconUrl(String iconCode) {
    return 'https://openweathermap.org/img/wn/$iconCode@2x.png';
  }
  
  // Build complete URL for weather by city
  static String getWeatherByCityUrl(String city, String units) {
    return '$baseUrl$weatherEndpoint?q=$city&appid=$apiKey&units=$units';
  }
  
  // Build complete URL for weather by coordinates
  static String getWeatherByCoordinatesUrl(
    double lat,
    double lon,
    String units,
  ) {
    return '$baseUrl$weatherEndpoint?lat=$lat&lon=$lon&appid=$apiKey&units=$units';
  }
}