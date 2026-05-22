import 'package:flutter/material.dart';

class AppColors {
  // Primary Colors
  static const Color primary = Color(0xFF1A237E); // Dark Blue
  static const Color primaryLight = Color(0xFF283593);
  static const Color primaryDark = Color(0xFF0D1642);

  // Accent Color
  static const Color accent = Color(0xFF880E4F); // Maroon
  static const Color accentLight = Color(0xFFAD1457);

  // Neutrals
  static const Color white = Colors.white;
  static const Color black = Colors.black;
  static const Color grey = Color(0xFF9E9E9E);
  static const Color greyLight = Color(0xFFF5F5F5);
  static const Color greyDark = Color(0xFF616161);

  // Background
  static const Color background = Color(0xFFFAFAFA);
  static const Color surface = Colors.white;

  // Dark Mode
  static const Color darkBackground = Color(0xFF121212);
  static const Color darkSurface = Color(0xFF1E1E1E);
  static const Color darkCard = Color(0xFF2C2C2C);

  // Status Colors
  static const Color success = Color(0xFF4CAF50);
  static const Color error = Color(0xFFE53935);
  static const Color warning = Color(0xFFFFA726);
  static const Color info = Color(0xFF29B6F6);

  // Gradient
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primary, accent],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient bannerGradient = LinearGradient(
    colors: [Color(0xFF1A237E), Color(0xFF4A148C)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
