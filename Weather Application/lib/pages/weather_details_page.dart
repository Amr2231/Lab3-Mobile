import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/weather_provider.dart';
import '../providers/favorites_provider.dart';
import '../widgets/weather_detail_item.dart';
import '../utils/constants.dart';
import '../utils/helpers.dart';
import '../config/api_config.dart';



class WeatherDetailsPage extends StatelessWidget {
  const WeatherDetailsPage({Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Consumer<WeatherProvider>(
        builder: (context, weatherProvider, child) {
          if (!weatherProvider.hasWeather) {
            return const Center(
              child: Text('No weather data available'),
            );
          }
          
          final weather = weatherProvider.currentWeather!;
          
          return CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 300,
                pinned: true,
                backgroundColor: AppColors.primary,
                flexibleSpace: FlexibleSpaceBar(
                  background: Container(
                    decoration: const BoxDecoration(
                      gradient: AppColors.primaryGradient,
                    ),
                    child: SafeArea(
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Icon(
                                  Icons.location_on,
                                  color: Colors.white,
                                  size: 24,
                                ),
                                const SizedBox(width: 4),
                                Expanded(
                                  child: Text(
                                    weather.fullLocation,
                                    style: AppTextStyles.heading2.copyWith(
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            
                            const SizedBox(height: 8),
                            
                            Text(
                              WeatherHelpers.getFullDateTime(
                                weather.dt,
                                weather.timezone,
                              ),
                              style: AppTextStyles.body.copyWith(
                                color: Colors.white.withOpacity(0.9),
                              ),
                            ),
                            
                            const SizedBox(height: 24),
                            
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Image.network(
                                  ApiConfig.getIconUrl(weather.icon),
                                  width: 100,
                                  height: 100,
                                  errorBuilder: (context, error, stackTrace) {
                                    return const Icon(
                                      Icons.wb_sunny,
                                      size: 80,
                                      color: Colors.white,
                                    );
                                  },
                                ),
                                const SizedBox(width: 16),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '${weather.temperature.round()}°',
                                      style: const TextStyle(
                                        fontSize: 72,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                    Text(
                                      WeatherHelpers.capitalizeWords(
                                        weather.description,
                                      ),
                                      style: AppTextStyles.heading3.copyWith(
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                actions: [
                  Consumer<FavoritesProvider>(
                    builder: (context, favProvider, child) {
                      final isFav = favProvider.isFavorite(
                        weather.cityName,
                        weather.country,
                      );
                      
                      return IconButton(
                        icon: Icon(
                          isFav ? Icons.favorite : Icons.favorite_border,
                          color: isFav ? Colors.red : Colors.white,
                        ),
                        onPressed: () {
                          favProvider.toggleFavorite(
                            weather.cityName,
                            weather.country,
                          );
                          
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                isFav
                                    ? 'Removed from favorites'
                                    : 'Added to favorites',
                              ),
                              duration: const Duration(seconds: 1),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
              
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Feels Like
                      Text(
                        'Feels like ${weather.feelsLike.round()}°',
                        style: AppTextStyles.heading3,
                      ),
                      
                      const SizedBox(height: 24),
                      
                      GridView.count(
                        crossAxisCount: 2,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        mainAxisSpacing: 16,
                        crossAxisSpacing: 16,
                        childAspectRatio: 1.3,
                        children: [
                          WeatherDetailItem(
                            icon: Icons.water_drop,
                            label: 'Humidity',
                            value: '${weather.humidity}%',
                            iconColor: AppColors.rainy,
                          ),
                          WeatherDetailItem(
                            icon: Icons.air,
                            label: 'Wind Speed',
                            value: WeatherHelpers.formatWindSpeed(
                              weather.windSpeed,
                            ),
                            iconColor: AppColors.cloudy,
                          ),
                          WeatherDetailItem(
                            icon: Icons.compress,
                            label: 'Pressure',
                            value: '${weather.pressure} hPa',
                            iconColor: AppColors.primary,
                          ),
                          WeatherDetailItem(
                            icon: Icons.visibility,
                            label: 'Visibility',
                            value: WeatherHelpers.formatVisibility(
                              weather.visibility,
                            ),
                            iconColor: AppColors.accent,
                          ),
                        ],
                      ),
                      
                      const SizedBox(height: 24),
                      
                      Text(
                        'Sun Times',
                        style: AppTextStyles.heading3,
                      ),
                      
                      const SizedBox(height: 16),
                      
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: AppColors.cardBackground,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 10,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            WeatherDetailItemHorizontal(
                              icon: Icons.wb_sunny,
                              label: 'Sunrise',
                              value: WeatherHelpers.formatTime(
                                weather.sunrise,
                                weather.timezone,
                              ),
                              iconColor: AppColors.sunny,
                            ),
                            const Divider(height: 24),
                            WeatherDetailItemHorizontal(
                              icon: Icons.nightlight_round,
                              label: 'Sunset',
                              value: WeatherHelpers.formatTime(
                                weather.sunset,
                                weather.timezone,
                              ),
                              iconColor: AppColors.warning,
                            ),
                          ],
                        ),
                      ),
                      
                      const SizedBox(height: 24),
                      
                      if (weather.tempMin != null && weather.tempMax != null)
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: AppColors.cardBackground,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 10,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Column(
                                children: [
                                  const Icon(
                                    Icons.arrow_downward,
                                    color: AppColors.primary,
                                  ),
                                  const SizedBox(height: 4),
                                  const Text('Min'),
                                  Text(
                                    '${weather.tempMin!.round()}°',
                                    style: AppTextStyles.heading2,
                                  ),
                                ],
                              ),
                              Column(
                                children: [
                                  const Icon(
                                    Icons.arrow_upward,
                                    color: AppColors.error,
                                  ),
                                  const SizedBox(height: 4),
                                  const Text('Max'),
                                  Text(
                                    '${weather.tempMax!.round()}°',
                                    style: AppTextStyles.heading2,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}