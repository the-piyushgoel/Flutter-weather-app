import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

/// Full-screen shimmer loading skeleton that mimics the home screen layout.
///
/// Displays animated placeholder shapes while weather data is loading.
class ShimmerLoading extends StatelessWidget {
  const ShimmerLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.white.withValues(alpha: 0.15),
      highlightColor: Colors.white.withValues(alpha: 0.3),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 60),
            // Weather emoji placeholder
            _shimmerBox(80, 80, radius: 40),
            const SizedBox(height: 24),
            // Temperature placeholder
            _shimmerBox(180, 80, radius: 16),
            const SizedBox(height: 16),
            // City name placeholder
            _shimmerBox(160, 28, radius: 8),
            const SizedBox(height: 12),
            // Description placeholder
            _shimmerBox(120, 20, radius: 6),
            const SizedBox(height: 48),
            // Detail chips row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _shimmerBox(90, 110, radius: 20),
                _shimmerBox(90, 110, radius: 20),
                _shimmerBox(90, 110, radius: 20),
              ],
            ),
            const SizedBox(height: 20),
            // Second detail row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _shimmerBox(90, 110, radius: 20),
                _shimmerBox(90, 110, radius: 20),
                _shimmerBox(90, 110, radius: 20),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// Creates a single shimmer placeholder box.
  Widget _shimmerBox(double width, double height, {double radius = 12}) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(radius),
      ),
    );
  }
}
