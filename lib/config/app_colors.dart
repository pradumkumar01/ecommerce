import 'package:flutter/material.dart';

class AppColors {
  // Light Theme Colors
  static const Color lightPrimary = Color(0xFF6C5CE7);
  static const Color lightPrimaryDark = Color(0xFF5F3DC4);
  static const Color lightAccent = Color(0xFFFF6B6B);
  static const Color lightBackground = Color(0xFFFAFAFA);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightText = Color(0xFF1A1A1A);
  static const Color lightTextSecondary = Color(0xFF666666);
  static const Color lightBorder = Color(0xFFE0E0E0);
  static const Color lightDivider = Color(0xFFEAEAEA);
  static const Color lightSuccess = Color(0xFF27AE60);
  static const Color lightWarning = Color(0xFFF39C12);
  static const Color lightError = Color(0xFFE74C3C);
  static const Color lightInfo = Color(0xFF3498DB);
  static const Color lightDisabled = Color(0xFFBDBDBD);
  static const Color lightOverlay = Color(0x00000000);

  // Dark Theme Colors
  static const Color darkPrimary = Color(0xFF6C5CE7);
  static const Color darkPrimaryDark = Color(0xFF5F3DC4);
  static const Color darkAccent = Color(0xFFFF6B6B);
  static const Color darkBackground = Color(0xFF1A1A1A);
  static const Color darkSurface = Color(0xFF2D2D2D);
  static const Color darkText = Color(0xFFFFFFFF);
  static const Color darkTextSecondary = Color(0xFFB0B0B0);
  static const Color darkBorder = Color(0xFF404040);
  static const Color darkDivider = Color(0xFF333333);
  static const Color darkSuccess = Color(0xFF27AE60);
  static const Color darkWarning = Color(0xFFF39C12);
  static const Color darkError = Color(0xFFE74C3C);
  static const Color darkInfo = Color(0xFF3498DB);
  static const Color darkDisabled = Color(0xFF525252);
  static const Color darkOverlay = Color(0x1AFFFFFF);

  // Neutral Colors
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);
  static const Color transparent = Color(0x00000000);

  // Star Rating
  static const Color starColor = Color(0xFFFFC107);

  // Gradient Colors
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [lightPrimary, lightPrimaryDark],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient accentGradient = LinearGradient(
    colors: [lightAccent, Color(0xFFFF8A80)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
