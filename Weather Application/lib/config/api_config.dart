

class ApiConfig {
  static const String apiKey = 'e1e84edc70e73d6f3cd7f311eca9890d';
  
  static const String baseUrl = 'https://api.openweathermap.org/data/2.5';
  
  static const String weatherEndpoint = '/weather';
  
  static String getIconUrl(String iconCode) {
    return 'https://openweathermap.org/img/wn/$iconCode@2x.png';
  }
  
  static String getWeatherByCityUrl(String city, String units) {
    return '$baseUrl$weatherEndpoint?q=$city&appid=$apiKey&units=$units';
  }
  
  static String getWeatherByCoordinatesUrl(
    double lat,
    double lon,
    String units,
  ) {
    return '$baseUrl$weatherEndpoint?lat=$lat&lon=$lon&appid=$apiKey&units=$units';
  }
}