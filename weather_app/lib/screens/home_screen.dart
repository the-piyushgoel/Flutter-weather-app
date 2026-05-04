import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../config/constants.dart';
import '../models/weather_model.dart';
import '../services/weather_service.dart';
import '../widgets/weather_card.dart';
import '../widgets/detail_chip.dart';
import '../widgets/shimmer_loading.dart';
import '../widgets/error_view.dart';
import 'search_screen.dart';

/// Home screen — the main weather display with dynamic gradient background,
/// pull-to-refresh, glassmorphism detail cards, and smooth animations.
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  final WeatherService _weatherService = WeatherService();

  WeatherData? _weather;
  bool _isLoading = true;
  String? _errorMessage;
  String _currentCity = AppConstants.defaultCity;

  // Animation controllers
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;
  late AnimationController _gradientController;

  // Current and target gradient colors for smooth transitions
  List<Color> _currentGradient = AppConstants.defaultGradient;
  List<Color> _targetGradient = AppConstants.defaultGradient;

  @override
  void initState() {
    super.initState();

    // Fade-in animation for content
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeOutCubic,
    );

    // Gradient transition animation
    _gradientController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    )..addListener(() {
        setState(() {}); // Rebuild for gradient interpolation
      });

    _loadLastCityAndFetch();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _gradientController.dispose();
    _weatherService.dispose();
    super.dispose();
  }

  /// Loads the last searched city from SharedPreferences and fetches its weather.
  Future<void> _loadLastCityAndFetch() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedCity = prefs.getString('last_city');
      if (savedCity != null && savedCity.isNotEmpty) {
        _currentCity = savedCity;
      }
    } catch (_) {
      // Ignore shared preferences errors
    }
    await _fetchWeather(_currentCity);
  }

  /// Fetches weather for [city] and updates UI state.
  Future<void> _fetchWeather(String city) async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    _fadeController.reset();

    try {
      final weather = await _weatherService.fetchWeather(city);

      // Save to SharedPreferences
      try {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('last_city', city);
      } catch (_) {}

      // Update gradient with smooth transition
      final newGradient = AppConstants.getGradient(
        weather.condition,
        isNight: weather.isNight,
      );
      _currentGradient = _interpolatedGradient;
      _targetGradient = newGradient;
      _gradientController.forward(from: 0);

      setState(() {
        _weather = weather;
        _currentCity = city;
        _isLoading = false;
      });
      _fadeController.forward();
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = e.toString();
      });
    }
  }

  /// Computes the interpolated gradient based on animation progress.
  List<Color> get _interpolatedGradient {
    final t = _gradientController.value;
    if (_currentGradient.length != _targetGradient.length) {
      return _targetGradient;
    }
    return List.generate(
      _currentGradient.length,
      (i) => Color.lerp(_currentGradient[i], _targetGradient[i], t)!,
    );
  }

  /// Navigates to search screen and fetches weather for the selected city.
  Future<void> _navigateToSearch() async {
    final selectedCity = await Navigator.push<String>(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            const SearchScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(1, 0),
              end: Offset.zero,
            ).animate(CurvedAnimation(
              parent: animation,
              curve: Curves.easeOutCubic,
            )),
            child: child,
          );
        },
        transitionDuration: const Duration(milliseconds: 400),
      ),
    );

    if (selectedCity != null && selectedCity.isNotEmpty) {
      await _fetchWeather(selectedCity);
    }
  }

  @override
  Widget build(BuildContext context) {
    final gradientColors = _interpolatedGradient;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Weather',
          style: GoogleFonts.outfit(
            fontSize: 20,
            fontWeight: FontWeight.w500,
            color: Colors.white.withValues(alpha: 0.8),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search_rounded, color: Colors.white, size: 28),
            tooltip: 'Search city',
            onPressed: _navigateToSearch,
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: AnimatedContainer(
        duration: const Duration(milliseconds: 600),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: gradientColors,
          ),
        ),
        child: SafeArea(
          child: _buildBody(),
        ),
      ),
    );
  }

  Widget _buildBody() {
    // Loading state
    if (_isLoading) {
      return const ShimmerLoading();
    }

    // Error state
    if (_errorMessage != null) {
      return ErrorView(
        message: _errorMessage!,
        onRetry: () => _fetchWeather(_currentCity),
      );
    }

    // Success state
    if (_weather != null) {
      return RefreshIndicator(
        onRefresh: () => _fetchWeather(_currentCity),
        color: Colors.white,
        backgroundColor: Colors.white.withValues(alpha: 0.2),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(
            parent: BouncingScrollPhysics(),
          ),
          child: SizedBox(
            height: MediaQuery.of(context).size.height -
                MediaQuery.of(context).padding.top -
                kToolbarHeight,
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: _buildWeatherContent(),
            ),
          ),
        ),
      );
    }

    return const SizedBox.shrink();
  }

  Widget _buildWeatherContent() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          const Spacer(flex: 2),

          // Hero weather card (icon + temp + city + condition)
          WeatherCard(weather: _weather!),

          const Spacer(flex: 2),

          // Detail chips — row 1
          Row(
            children: [
              Expanded(
                child: DetailChip(
                  icon: Icons.water_drop_rounded,
                  label: 'Humidity',
                  value: '${_weather!.humidity}%',
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: DetailChip(
                  icon: Icons.air_rounded,
                  label: 'Wind',
                  value: '${_weather!.windSpeed} m/s',
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: DetailChip(
                  icon: Icons.thermostat_rounded,
                  label: 'Feels Like',
                  value: '${_weather!.feelsLike.round()}°',
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Detail chips — row 2
          Row(
            children: [
              Expanded(
                child: DetailChip(
                  icon: Icons.compress_rounded,
                  label: 'Pressure',
                  value: '${_weather!.pressure} hPa',
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: DetailChip(
                  icon: Icons.visibility_rounded,
                  label: 'Visibility',
                  value: '${(_weather!.visibility / 1000).toStringAsFixed(1)} km',
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: DetailChip(
                  icon: Icons.cloud_rounded,
                  label: 'Clouds',
                  value: '${_weather!.cloudiness}%',
                ),
              ),
            ],
          ),

          const Spacer(flex: 1),

          // Last updated indicator
          Text(
            'Pull down to refresh',
            style: GoogleFonts.outfit(
              fontSize: 12,
              fontWeight: FontWeight.w300,
              color: Colors.white.withValues(alpha: 0.35),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
