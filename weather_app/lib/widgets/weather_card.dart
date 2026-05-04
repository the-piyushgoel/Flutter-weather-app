import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/weather_model.dart';
import 'weather_icon_widget.dart';

/// Main weather card displaying the hero content:
/// animated weather icon, temperature, city name, and condition.
///
/// Uses [AnimatedSwitcher] for smooth transitions when data updates.
class WeatherCard extends StatelessWidget {
  final WeatherData weather;

  const WeatherCard({super.key, required this.weather});

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 600),
      switchInCurve: Curves.easeOutCubic,
      switchOutCurve: Curves.easeInCubic,
      transitionBuilder: (child, animation) {
        return FadeTransition(
          opacity: animation,
          child: SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0, 0.05),
              end: Offset.zero,
            ).animate(animation),
            child: child,
          ),
        );
      },
      child: Column(
        key: ValueKey('${weather.city}_${weather.dt}'),
        mainAxisSize: MainAxisSize.min,
        children: [
          // Animated weather icon
          WeatherIconWidget(
            iconCode: weather.icon,
            size: 80,
          ),
          const SizedBox(height: 8),

          // Temperature — hero display
          Text(
            '${weather.temperature.round()}°',
            style: GoogleFonts.outfit(
              fontSize: 96,
              fontWeight: FontWeight.w200,
              color: Colors.white,
              height: 1.1,
            ),
          ),
          const SizedBox(height: 4),

          // City name + country
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.location_on_rounded,
                color: Colors.white70,
                size: 20,
              ),
              const SizedBox(width: 4),
              Text(
                weather.country.isNotEmpty
                    ? '${weather.city}, ${weather.country}'
                    : weather.city,
                style: GoogleFonts.outfit(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // Weather condition description
          Text(
            weather.capitalizedDescription,
            style: GoogleFonts.outfit(
              fontSize: 18,
              fontWeight: FontWeight.w300,
              color: Colors.white.withValues(alpha: 0.7),
            ),
          ),

          // Min / Max temperature
          const SizedBox(height: 6),
          Text(
            'H: ${weather.tempMax.round()}°  L: ${weather.tempMin.round()}°',
            style: GoogleFonts.outfit(
              fontSize: 15,
              fontWeight: FontWeight.w400,
              color: Colors.white.withValues(alpha: 0.55),
            ),
          ),
        ],
      ),
    );
  }
}
