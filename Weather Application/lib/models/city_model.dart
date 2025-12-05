

class CityModel {
  final String name;
  final String country;
  final DateTime addedAt;
  
  CityModel({
    required this.name,
    required this.country,
    DateTime? addedAt,
  }) : addedAt = addedAt ?? DateTime.now();
  
  factory CityModel.fromJson(Map<String, dynamic> json) {
    return CityModel(
      name: json['name'] ?? '',
      country: json['country'] ?? '',
      addedAt: json['addedAt'] != null
          ? DateTime.parse(json['addedAt'])
          : DateTime.now(),
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'country': country,
      'addedAt': addedAt.toIso8601String(),
    };
  }
  
  String get fullLocation => country.isEmpty ? name : '$name, $country';
  
  factory CityModel.fromWeather(String cityName, String country) {
    return CityModel(
      name: cityName,
      country: country,
    );
  }
  
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is CityModel &&
        other.name.toLowerCase() == name.toLowerCase() &&
        other.country.toLowerCase() == country.toLowerCase();
  }
  
  @override
  int get hashCode => name.hashCode ^ country.hashCode;
  
  @override
  String toString() => fullLocation;
}