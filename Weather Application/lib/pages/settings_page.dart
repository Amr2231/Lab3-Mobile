import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/settings_provider.dart';
import '../providers/weather_provider.dart';
import '../utils/constants.dart';


class SettingsPage extends StatelessWidget {
  const SettingsPage({Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.textLight,
      ),
      body: ListView(
        children: [
          _buildSectionHeader('Temperature Unit'),
          
          Consumer<SettingsProvider>(
            builder: (context, settingsProvider, child) {
              return Column(
                children: [
                  RadioListTile<String>(
                    title: const Text('Celsius (°C)'),
                    subtitle: const Text('Metric system'),
                    value: AppConstants.metric,
                    groupValue: settingsProvider.temperatureUnit,
                    activeColor: AppColors.primary,
                    onChanged: (value) async {
                      if (value != null) {
                        await settingsProvider.setTemperatureUnit(value);
                        
                        // Update weather provider
                        final weatherProvider = context.read<WeatherProvider>();
                        weatherProvider.setTemperatureUnit(value);
                        
                        // Refresh weather data
                        if (weatherProvider.hasWeather) {
                          await weatherProvider.refreshWeather();
                        }
                        
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Temperature unit updated'),
                              duration: Duration(seconds: 1),
                            ),
                          );
                        }
                      }
                    },
                  ),
                  RadioListTile<String>(
                    title: const Text('Fahrenheit (°F)'),
                    subtitle: const Text('Imperial system'),
                    value: AppConstants.imperial,
                    groupValue: settingsProvider.temperatureUnit,
                    activeColor: AppColors.primary,
                    onChanged: (value) async {
                      if (value != null) {
                        await settingsProvider.setTemperatureUnit(value);
                        
                        final weatherProvider = context.read<WeatherProvider>();
                        weatherProvider.setTemperatureUnit(value);
                        
                        if (weatherProvider.hasWeather) {
                          await weatherProvider.refreshWeather();
                        }
                        
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Temperature unit updated'),
                              duration: Duration(seconds: 1),
                            ),
                          );
                        }
                      }
                    },
                  ),
                ],
              );
            },
          ),
          
          const Divider(height: 1),
          
          _buildSectionHeader('About'),
          
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: const Text('App Version'),
            subtitle: Text(AppConstants.appVersion),
          ),
          
          ListTile(
            leading: const Icon(Icons.cloud_outlined),
            title: const Text('Weather Data'),
            subtitle: const Text('Powered by OpenWeatherMap'),
            onTap: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Weather Data Source'),
                  content: const Text(
                    'This app uses OpenWeatherMap API to provide accurate and real-time weather information.\n\n'
                    'For more information, visit:\nwww.openweathermap.org',
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Close'),
                    ),
                  ],
                ),
              );
            },
          ),
          
          const Divider(height: 1),
          
          _buildSectionHeader('Developer'),
          
          ListTile(
            leading: const Icon(Icons.code),
            title: const Text('API Configuration'),
            subtitle: const Text('Manage API settings'),
            onTap: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('API Configuration'),
                  content: const Text(
                    'To use this app, you need an OpenWeatherMap API key.\n\n'
                    '1. Sign up at openweathermap.org\n'
                    '2. Get your API key\n'
                    '3. Add it to lib/config/api_config.dart\n\n'
                    'The API key is stored locally and never sent to any server except OpenWeatherMap.',
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('OK'),
                    ),
                  ],
                ),
              );
            },
          ),
          
          const SizedBox(height: 32),
          
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: OutlinedButton.icon(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Reset Settings'),
                    content: const Text(
                      'Are you sure you want to reset all settings to default?',
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () {
                          context.read<SettingsProvider>().resetSettings();
                          Navigator.pop(context);
                          
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Settings reset to default'),
                            ),
                          );
                        },
                        child: const Text(
                          'Reset',
                          style: TextStyle(color: AppColors.error),
                        ),
                      ),
                    ],
                  ),
                );
              },
              icon: const Icon(Icons.restore),
              label: const Text('Reset to Default'),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.error,
                side: const BorderSide(color: AppColors.error),
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),
          
          const SizedBox(height: 32),
        ],
      ),
    );
  }
  
  Widget _buildSectionHeader(String title) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      color: AppColors.background,
      child: Text(
        title,
        style: AppTextStyles.body.copyWith(
          color: AppColors.primary,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}