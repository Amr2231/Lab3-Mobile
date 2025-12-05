import 'package:flutter/material.dart';
import '../pages/home_page.dart';
import '../pages/weather_details_page.dart';
import '../pages/favorites_page.dart';
import '../pages/settings_page.dart';

/// App Routes
/// 
/// Centralized route management

class AppRoutes {
  // Route Names
  static const String home = '/';
  static const String weatherDetails = '/weather-details';
  static const String favorites = '/favorites';
  static const String settings = '/settings';
  
  // Route Generator
static Route<dynamic> generateRoute(RouteSettings routeSettings) {
  switch (routeSettings.name) {
    case AppRoutes.home:
      return MaterialPageRoute(builder: (_) => const HomePage());

    case AppRoutes.weatherDetails:
      return MaterialPageRoute(builder: (_) => const WeatherDetailsPage());

    case AppRoutes.favorites:
      return MaterialPageRoute(builder: (_) => const FavoritesPage());

    case AppRoutes.settings:
      return MaterialPageRoute(builder: (_) => const SettingsPage());

    default:
      return MaterialPageRoute(
        builder: (_) => Scaffold(
          body: Center(
            child: Text('No route defined for ${routeSettings.name}'),
          ),
        ),
      );
  }
}

  
  // Navigation Helper Methods
  static void navigateToHome(BuildContext context) {
    Navigator.pushNamedAndRemoveUntil(context, home, (route) => false);
  }
  
  static void navigateToWeatherDetails(BuildContext context) {
    Navigator.pushNamed(context, weatherDetails);
  }
  
  static void navigateToFavorites(BuildContext context) {
    Navigator.pushNamed(context, favorites);
  }
  
  static void navigateToSettings(BuildContext context) {
    Navigator.pushNamed(context, settings);
  }
}