import 'package:flutter/material.dart';

import '../colors.dart';

class AppTheme {
  AppTheme._();

  static final ThemeData light = ThemeData(
    useMaterial3: true,
    fontFamily: 'Roboto',
    brightness: Brightness.light,
    colorScheme: const ColorScheme.light(
      primary: forest,
      onPrimary: Colors.white,
      secondary: Color(0xFF9C6B83),
      onSecondary: Colors.white,
      surface: paper,
      onSurface: Color(0xFF244C3A),
      error: Color(0xFFB3261E),
    ),
    scaffoldBackgroundColor: paper,
    appBarTheme: const AppBarTheme(
      backgroundColor: paper,
      foregroundColor: forest,
      elevation: 0,
      scrolledUnderElevation: 0,
    ),
    cardTheme: CardThemeData(
      color: Colors.white.withValues(alpha: 0.58),
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: const BorderSide(color: Color(0xFFE8DCE2)),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white.withValues(alpha: 0.65),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide.none,
      ),
      contentPadding: const EdgeInsets.all(16),
    ),
  );

  static final ThemeData dark = ThemeData(
    useMaterial3: true,
    fontFamily: 'Roboto',
    brightness: Brightness.dark,
    colorScheme: const ColorScheme.dark(
      primary: Color(0xFFA7D5B5),
      onPrimary: Color(0xFF163626),
      secondary: Color(0xFFE5B8CE),
      onSecondary: Color(0xFF442638),
      surface: Color(0xFF202923),
      onSurface: Color(0xFFE8EEE9),
      error: Color(0xFFFFB4AB),
    ),
    scaffoldBackgroundColor: const Color(0xFF151B17),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF151B17),
      foregroundColor: Color(0xFFE8EEE9),
      elevation: 0,
      scrolledUnderElevation: 0,
    ),
    cardTheme: CardThemeData(
      color: const Color(0xFF202923),
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: const BorderSide(color: Color(0xFF354239)),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: const Color(0xFF202923),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide.none,
      ),
      contentPadding: const EdgeInsets.all(16),
    ),
  );
}
