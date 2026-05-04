/// Weather data model — maps the clean JSON from our backend.
class WeatherData {
  final String city;
  final String country;
  final double temperature;
  final double feelsLike;
  final double tempMin;
  final double tempMax;
  final String condition;
  final String description;
  final int humidity;
  final double windSpeed;
  final String icon;
  final int pressure;
  final int visibility;
  final int cloudiness;
  final int sunrise;
  final int sunset;
  final int timezone;
  final int dt;

  WeatherData({
    required this.city,
    required this.country,
    required this.temperature,
    required this.feelsLike,
    required this.tempMin,
    required this.tempMax,
    required this.condition,
    required this.description,
    required this.humidity,
    required this.windSpeed,
    required this.icon,
    required this.pressure,
    required this.visibility,
    required this.cloudiness,
    required this.sunrise,
    required this.sunset,
    required this.timezone,
    required this.dt,
  });

  /// Creates a [WeatherData] from the backend JSON response.
  factory WeatherData.fromJson(Map<String, dynamic> json) {
    return WeatherData(
      city: json['city'] as String? ?? 'Unknown',
      country: json['country'] as String? ?? '',
      temperature: (json['temperature'] as num?)?.toDouble() ?? 0.0,
      feelsLike: (json['feelsLike'] as num?)?.toDouble() ?? 0.0,
      tempMin: (json['tempMin'] as num?)?.toDouble() ?? 0.0,
      tempMax: (json['tempMax'] as num?)?.toDouble() ?? 0.0,
      condition: json['condition'] as String? ?? 'Unknown',
      description: json['description'] as String? ?? '',
      humidity: json['humidity'] as int? ?? 0,
      windSpeed: (json['windSpeed'] as num?)?.toDouble() ?? 0.0,
      icon: json['icon'] as String? ?? '01d',
      pressure: json['pressure'] as int? ?? 0,
      visibility: json['visibility'] as int? ?? 0,
      cloudiness: json['cloudiness'] as int? ?? 0,
      sunrise: json['sunrise'] as int? ?? 0,
      sunset: json['sunset'] as int? ?? 0,
      timezone: json['timezone'] as int? ?? 0,
      dt: json['dt'] as int? ?? 0,
    );
  }

  /// Whether it's currently nighttime at the weather location.
  bool get isNight {
    if (sunrise == 0 || sunset == 0) return false;
    final now = DateTime.now().toUtc().add(Duration(seconds: timezone));
    final sunriseTime =
        DateTime.fromMillisecondsSinceEpoch(sunrise * 1000, isUtc: true)
            .add(Duration(seconds: timezone));
    final sunsetTime =
        DateTime.fromMillisecondsSinceEpoch(sunset * 1000, isUtc: true)
            .add(Duration(seconds: timezone));
    return now.isBefore(sunriseTime) || now.isAfter(sunsetTime);
  }

  /// Formatted description with first letter capitalized.
  String get capitalizedDescription {
    if (description.isEmpty) return '';
    return description[0].toUpperCase() + description.substring(1);
  }
}
