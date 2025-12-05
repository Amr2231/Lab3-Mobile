import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/favorites_provider.dart';
import '../providers/weather_provider.dart';
import '../widgets/favorite_city_card.dart';
import '../widgets/loading_widget.dart';
import '../utils/constants.dart';
import '../routes/app_routes.dart';

/// Favorites Page
/// 
/// List of favorite cities

class FavoritesPage extends StatefulWidget {
  const FavoritesPage({Key? key}) : super(key: key);
  
  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  @override
  void initState() {
    super.initState();
    
    // Load favorites on page load
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<FavoritesProvider>().loadFavorites();
    });
  }
  
  void _openCityWeather(String cityName) async {
    // Fetch weather for the selected city
    await context.read<WeatherProvider>().fetchWeatherByCity(cityName);
    
    if (mounted) {
      // Navigate to details page
      AppRoutes.navigateToWeatherDetails(context);
    }
  }
  
  void _deleteCity(String cityName, String country) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Remove Favorite'),
        content: Text('Remove $cityName from favorites?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              context.read<FavoritesProvider>().removeFavorite(
                    cityName,
                    country,
                  );
              Navigator.pop(context);
              
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('$cityName removed from favorites'),
                  duration: const Duration(seconds: 2),
                ),
              );
            },
            child: const Text(
              'Remove',
              style: TextStyle(color: AppColors.error),
            ),
          ),
        ],
      ),
    );
  }
  
  void _clearAllFavorites() {
    if (!context.read<FavoritesProvider>().hasFavorites) return;
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear All Favorites'),
        content: const Text('Are you sure you want to remove all favorites?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              context.read<FavoritesProvider>().clearAllFavorites();
              Navigator.pop(context);
              
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('All favorites cleared'),
                  duration: Duration(seconds: 2),
                ),
              );
            },
            child: const Text(
              'Clear All',
              style: TextStyle(color: AppColors.error),
            ),
          ),
        ],
      ),
    );
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Favorites'),
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.textLight,
        actions: [
          Consumer<FavoritesProvider>(
            builder: (context, favProvider, child) {
              if (favProvider.hasFavorites) {
                return IconButton(
                  icon: const Icon(Icons.delete_sweep),
                  onPressed: _clearAllFavorites,
                  tooltip: 'Clear all',
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ],
      ),
      body: Consumer<FavoritesProvider>(
        builder: (context, favProvider, child) {
          if (favProvider.isLoading) {
            return const LoadingWidget(
              message: 'Loading favorites...',
            );
          }
          
          if (!favProvider.hasFavorites) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.favorite_border,
                    size: 80,
                    color: AppColors.textSecondary.withOpacity(0.5),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No favorites yet',
                    style: AppTextStyles.heading3.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: Text(
                      'Add cities to favorites from the weather details page',
                      style: AppTextStyles.caption,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.search),
                    label: const Text('Search Cities'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }
          
          return Column(
            children: [
              // Header
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: AppColors.primaryGradient,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.favorite,
                      color: Colors.white,
                      size: 24,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      '${favProvider.favoritesCount} ${favProvider.favoritesCount == 1 ? 'City' : 'Cities'}',
                      style: AppTextStyles.heading3.copyWith(
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              
              // Favorites List
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(20),
                  itemCount: favProvider.favorites.length,
                  itemBuilder: (context, index) {
                    final city = favProvider.favorites[index];
                    
                    return FavoriteCityCard(
                      city: city,
                      onTap: () => _openCityWeather(city.name),
                      onDelete: () => _deleteCity(city.name, city.country),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}