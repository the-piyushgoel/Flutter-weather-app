import 'package:flutter/material.dart';
import '../config/constants.dart';

/// Displays the weather icon as a large emoji with a subtle pulse animation.
///
/// Maps OpenWeatherMap icon codes to emojis via [AppConstants].
class WeatherIconWidget extends StatefulWidget {
  final String iconCode;
  final double size;

  const WeatherIconWidget({
    super.key,
    required this.iconCode,
    this.size = 80,
  });

  @override
  State<WeatherIconWidget> createState() => _WeatherIconWidgetState();
}

class _WeatherIconWidgetState extends State<WeatherIconWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    )..repeat(reverse: true);

    _scaleAnimation = Tween<double>(begin: 0.95, end: 1.05).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: Text(
        AppConstants.getWeatherEmoji(widget.iconCode),
        style: TextStyle(fontSize: widget.size),
      ),
    );
  }
}
