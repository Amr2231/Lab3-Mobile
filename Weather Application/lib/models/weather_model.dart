/// Weather Data Model
/// 
/// Represents the complete weather information from OpenWeatherMap API

class WeatherModel {
  final String cityName;
  final String country;
  final double temperature;
  final double feelsLike;
  final int humidity;
  final double windSpeed;
  final String description;
  final String mainCondition;
  final String icon;
  final int sunrise;
  final int sunset;
  final int timezone;
  final int pressure;
  final int visibility;
  final double? tempMin;
  final double? tempMax;
  final int dt; // Current time
  
  WeatherModel({
    required this.cityName,
    required this.country,
    required this.temperature,
    required this.feelsLike,
    required this.humidity,
    required this.windSpeed,
    required this.description,
    required this.mainCondition,
    required this.icon,
    required this.sunrise,
    required this.sunset,
    required this.timezone,
    required this.pressure,
    required this.visibility,
    this.tempMin,
    this.tempMax,
    required this.dt,
  });
  
  /// Create WeatherModel from JSON response
  factory WeatherModel.fromJson(Map<String, dynamic> json) {
    return WeatherModel(
      cityName: json['name'] ?? 'Unknown',
      country: json['sys']?['country'] ?? '',
      temperature: (json['main']?['temp'] ?? 0).toDouble(),
      feelsLike: (json['main']?['feels_like'] ?? 0).toDouble(),
      humidity: json['main']?['humidity'] ?? 0,
      windSpeed: (json['wind']?['speed'] ?? 0).toDouble(),
      description: json['weather']?[0]?['description'] ?? 'No description',
      mainCondition: json['weather']?[0]?['main'] ?? 'Unknown',
      icon: json['weather']?[0]?['icon'] ?? '01d',
      sunrise: json['sys']?['sunrise'] ?? 0,
      sunset: json['sys']?['sunset'] ?? 0,
      timezone: json['timezone'] ?? 0,
      pressure: json['main']?['pressure'] ?? 0,
      visibility: json['visibility'] ?? 0,
      tempMin: json['main']?['temp_min']?.toDouble(),
      tempMax: json['main']?['temp_max']?.toDouble(),
      dt: json['dt'] ?? DateTime.now().millisecondsSinceEpoch ~/ 1000,
    );
  }
  
  /// Convert WeatherModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'name': cityName,
      'sys': {'country': country, 'sunrise': sunrise, 'sunset': sunset},
      'main': {
        'temp': temperature,
        'feels_like': feelsLike,
        'humidity': humidity,
        'pressure': pressure,
        'temp_min': tempMin,
        'temp_max': tempMax,
      },
      'wind': {'speed': windSpeed},
      'weather': [
        {
          'description': description,
          'main': mainCondition,
          'icon': icon,
        }
      ],
      'timezone': timezone,
      'visibility': visibility,
      'dt': dt,
    };
  }
  
  /// Get full location string
  String get fullLocation => '$cityName, $country';
  
  /// Copy with method for updates
  WeatherModel copyWith({
    String? cityName,
    String? country,
    double? temperature,
    double? feelsLike,
    int? humidity,
    double? windSpeed,
    String? description,
    String? mainCondition,
    String? icon,
    int? sunrise,
    int? sunset,
    int? timezone,
    int? pressure,
    int? visibility,
    double? tempMin,
    double? tempMax,
    int? dt,
  }) {
    return WeatherModel(
      cityName: cityName ?? this.cityName,
      country: country ?? this.country,
      temperature: temperature ?? this.temperature,
      feelsLike: feelsLike ?? this.feelsLike,
      humidity: humidity ?? this.humidity,
      windSpeed: windSpeed ?? this.windSpeed,
      description: description ?? this.description,
      mainCondition: mainCondition ?? this.mainCondition,
      icon: icon ?? this.icon,
      sunrise: sunrise ?? this.sunrise,
      sunset: sunset ?? this.sunset,
      timezone: timezone ?? this.timezone,
      pressure: pressure ?? this.pressure,
      visibility: visibility ?? this.visibility,
      tempMin: tempMin ?? this.tempMin,
      tempMax: tempMax ?? this.tempMax,
      dt: dt ?? this.dt,
    );
  }
}