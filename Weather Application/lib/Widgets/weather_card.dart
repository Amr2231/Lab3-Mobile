import 'package:flutter/material.dart';
import '../models/weather_model.dart';
import '../utils/constants.dart';
import '../utils/helpers.dart';
import '../config/api_config.dart';



class WeatherCard extends StatelessWidget {
  final WeatherModel weather;
  final VoidCallback? onTap;
  
  const WeatherCard({
    Key? key,
    required this.weather,
    this.onTap,
  }) : super(key: key);
  
  LinearGradient _getGradientForWeather() {
    switch (weather.mainCondition.toLowerCase()) {
      case 'clear':
        return AppColors.sunnyGradient;
      case 'clouds':
        return AppColors.cloudyGradient;
      case 'rain':
      case 'drizzle':
      case 'thunderstorm':
        return AppColors.rainyGradient;
      default:
        return AppColors.primaryGradient;
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          gradient: _getGradientForWeather(),
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.location_on,
                  color: AppColors.textLight,
                  size: 20,
                ),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    weather.fullLocation,
                    style: AppTextStyles.heading3.copyWith(
                      color: AppColors.textLight,
                    ),
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 8),
            
            Text(
              WeatherHelpers.formatDate(weather.dt),
              style: AppTextStyles.caption.copyWith(
                color: AppColors.textLight.withOpacity(0.9),
              ),
            ),
            
            const SizedBox(height: 24),
            
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Weather Icon
                Image.network(
                  ApiConfig.getIconUrl(weather.icon),
                  width: 100,
                  height: 100,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Icon(
                        Icons.wb_sunny,
                        size: 50,
                        color: AppColors.textLight,
                      ),
                    );
                  },
                ),
                
                const SizedBox(width: 16),
                
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${weather.temperature.round()}°',
                        style: AppTextStyles.temperature,
                      ),
                      Text(
                        WeatherHelpers.capitalizeWords(weather.description),
                        style: AppTextStyles.heading3.copyWith(
                          color: AppColors.textLight,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Feels like ${weather.feelsLike.round()}°',
                        style: AppTextStyles.body.copyWith(
                          color: AppColors.textLight.withOpacity(0.9),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 24),
            
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildQuickStat(
                  Icons.water_drop,
                  'Humidity',
                  '${weather.humidity}%',
                ),
                _buildQuickStat(
                  Icons.air,
                  'Wind',
                  WeatherHelpers.formatWindSpeed(weather.windSpeed),
                ),
                _buildQuickStat(
                  Icons.compress,
                  'Pressure',
                  '${weather.pressure} hPa',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildQuickStat(IconData icon, String label, String value) {
    return Column(
      children: [
        Icon(
          icon,
          color: AppColors.textLight,
          size: 24,
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: AppTextStyles.caption.copyWith(
            color: AppColors.textLight.withOpacity(0.8),
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: AppTextStyles.bodySecondary.copyWith(
            color: AppColors.textLight,
          ),
        ),
      ],
    );
  }
}