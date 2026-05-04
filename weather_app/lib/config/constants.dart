import 'package:flutter/material.dart';

/// App-wide constants: API configuration, color palettes, gradients.
class AppConstants {
  AppConstants._(); // Prevent instantiation

  // ── API Configuration ──────────────────────────────────────────────────────
  // Use 10.0.2.2 for Android emulator, localhost for web/desktop
  static const String baseUrl = 'http://10.0.2.2:3000';
  static const String weatherEndpoint = '/weather';
  static const String defaultCity = 'London';
  static const Duration apiTimeout = Duration(seconds: 15);

  // ── Gradient Themes by Weather Condition ────────────────────────────────────
  static const Map<String, List<Color>> weatherGradients = {
    // Day conditions
    'Clear': [Color(0xFFFF6B35), Color(0xFFFFC371)],
    'Clouds': [Color(0xFF667EEA), Color(0xFF764BA2)],
    'Rain': [Color(0xFF1A2A6C), Color(0xFF414D6B)],
    'Drizzle': [Color(0xFF2C3E50), Color(0xFF4CA1AF)],
    'Thunderstorm': [Color(0xFF240B36), Color(0xFFC31432)],
    'Snow': [Color(0xFFE0EAFC), Color(0xFFCFDEF3)],
    'Mist': [Color(0xFF606C88), Color(0xFF3F4C6B)],
    'Fog': [Color(0xFF606C88), Color(0xFF3F4C6B)],
    'Haze': [Color(0xFF948E99), Color(0xFF2E1437)],
    'Smoke': [Color(0xFF56545A), Color(0xFF2C2C2E)],
    'Dust': [Color(0xFFB79891), Color(0xFF94716B)],
    'Sand': [Color(0xFFB79891), Color(0xFF94716B)],
    'Ash': [Color(0xFF56545A), Color(0xFF2C2C2E)],
    'Squall': [Color(0xFF1A2A6C), Color(0xFF414D6B)],
    'Tornado': [Color(0xFF240B36), Color(0xFF3B1A45)],
  };

  // Night gradient (used when isNight = true)
  static const List<Color> nightGradient = [
    Color(0xFF0F2027),
    Color(0xFF203A43),
    Color(0xFF2C5364),
  ];

  // Default / fallback gradient
  static const List<Color> defaultGradient = [
    Color(0xFF4A00E0),
    Color(0xFF8E2DE2),
  ];

  /// Returns the gradient colors for a given weather condition.
  static List<Color> getGradient(String condition, {bool isNight = false}) {
    if (isNight) return nightGradient;
    return weatherGradients[condition] ?? defaultGradient;
  }

  // ── Glassmorphism Styling ──────────────────────────────────────────────────
  static const double glassBlur = 15.0;
  static const double glassBorderRadius = 24.0;
  static const Color glassColor = Color(0x30FFFFFF);
  static const Color glassBorderColor = Color(0x40FFFFFF);

  // ── Weather Emoji Icons ────────────────────────────────────────────────────
  static const Map<String, String> weatherEmojis = {
    '01d': '☀️',
    '01n': '🌙',
    '02d': '⛅',
    '02n': '☁️',
    '03d': '☁️',
    '03n': '☁️',
    '04d': '☁️',
    '04n': '☁️',
    '09d': '🌧️',
    '09n': '🌧️',
    '10d': '🌦️',
    '10n': '🌧️',
    '11d': '⛈️',
    '11n': '⛈️',
    '13d': '❄️',
    '13n': '❄️',
    '50d': '🌫️',
    '50n': '🌫️',
  };

  /// Returns emoji for the given OpenWeatherMap icon code.
  static String getWeatherEmoji(String iconCode) {
    return weatherEmojis[iconCode] ?? '🌤️';
  }
}
