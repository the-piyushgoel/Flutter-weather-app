import 'dart:ui';
import 'package:flutter/material.dart';
import '../config/constants.dart';

/// A reusable glassmorphism container with blur effect and translucent background.
///
/// Wraps any child widget with a frosted-glass appearance.
class GlassContainer extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final double? width;
  final double? height;
  final double borderRadius;
  final double blur;

  const GlassContainer({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(20),
    this.width,
    this.height,
    this.borderRadius = AppConstants.glassBorderRadius,
    this.blur = AppConstants.glassBlur,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
        child: Container(
          width: width,
          height: height,
          padding: padding,
          decoration: BoxDecoration(
            color: AppConstants.glassColor,
            borderRadius: BorderRadius.circular(borderRadius),
            border: Border.all(
              color: AppConstants.glassBorderColor,
              width: 1.5,
            ),
          ),
          child: child,
        ),
      ),
    );
  }
}
