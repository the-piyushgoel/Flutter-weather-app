import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/constants.dart';
import '../models/weather_model.dart';

/// Custom exception for weather API errors.
class WeatherException implements Exception {
  final String message;
  const WeatherException(this.message);

  @override
  String toString() => message;
}

/// Service responsible for fetching weather data from our Node.js backend.
class WeatherService {
  final http.Client _client;

  WeatherService({http.Client? client}) : _client = client ?? http.Client();

  /// Fetches weather data for the given [city] from the backend.
  ///
  /// Throws [WeatherException] on failure with a user-friendly message.
  Future<WeatherData> fetchWeather(String city) async {
    if (city.trim().isEmpty) {
      throw const WeatherException('Please enter a city name.');
    }

    final uri = Uri.parse(
      '${AppConstants.baseUrl}${AppConstants.weatherEndpoint}?city=${Uri.encodeComponent(city.trim())}',
    );

    try {
      final response = await _client
          .get(uri)
          .timeout(AppConstants.apiTimeout);

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body) as Map<String, dynamic>;
        return WeatherData.fromJson(json);
      }

      // Parse error message from backend
      final errorBody = jsonDecode(response.body) as Map<String, dynamic>;
      final errorMessage =
          errorBody['message'] as String? ?? 'Something went wrong.';

      if (response.statusCode == 404) {
        throw WeatherException('City "$city" not found. Check the spelling and try again.');
      }

      throw WeatherException(errorMessage);
    } on WeatherException {
      rethrow; // Let our custom exceptions pass through
    } on FormatException {
      throw const WeatherException('Received invalid data from the server.');
    } catch (e) {
      if (e.toString().contains('TimeoutException')) {
        throw const WeatherException(
          'Connection timed out. Please check your internet and try again.',
        );
      }
      throw const WeatherException(
        'Could not connect to the weather service.\nMake sure the backend server is running.',
      );
    }
  }

  /// Dispose the HTTP client when no longer needed.
  void dispose() {
    _client.close();
  }
}
