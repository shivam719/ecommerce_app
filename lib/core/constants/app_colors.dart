import 'package:flutter/material.dart';

/// AppColors defines the uniform color system for both Light and Dark (Night) modes.
/// Following Material 3 design guidelines.
abstract class AppColors {
  // Primary brand colors
  static const Color primary = Color(0xFF673AB7); // Deep Purple
  static const Color primaryLight = Color(0xFF9575CD);
  static const Color primaryDark = Color(0xFF512DA8);

  // Secondary / Accent colors
  static const Color secondary = Color(0xFFFF9800); // Orange / Rating Gold
  static const Color accent = Color(0xFF00BCD4); // Cyan

  // Light Theme background & surface
  static const Color lightBackground = Color(0xFFF8F9FA);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightCard = Color(0xFFFFFFFF);
  static const Color lightTextPrimary = Color(0xFF1F1F1F);
  static const Color lightTextSecondary = Color(0xFF757575);

  // Dark (Night) Theme background & surface
  static const Color darkBackground = Color(0xFF121212);
  static const Color darkSurface = Color(0xFF1E1E1E);
  static const Color darkCard = Color(0xFF242424);
  static const Color darkTextPrimary = Color(0xFFEEEEEE);
  static const Color darkTextSecondary = Color(0xFFB0B0B0);

  // Status & Utility Colors
  static const Color success = Color(0xFF4CAF50);
  static const Color warning = Color(0xFFFFC107);
  static const Color error = Color(0xFFE53935);
  static const Color offlineBar = Color(0xFFD32F2F);
  static const Color onlineBar = Color(0xFF388E3C);
}
