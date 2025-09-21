import 'package:flutter/material.dart';
import '../Colors/app_colors.dart';

class AppTheme {
  // 🌞 Light Theme
  static final ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: AppColors.tealPrimary,
    scaffoldBackgroundColor: AppColors.softMint,
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.tealPrimary,
      foregroundColor: Colors.white,
      elevation: 0,
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: AppColors.tealPrimary,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.tealPrimary,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    ),
    colorScheme: const ColorScheme.light(
      primary: AppColors.tealPrimary,
      secondary: AppColors.mintGreen,
      surface: AppColors.softMint,
      error: Colors.redAccent,
    ),
    cardTheme: CardThemeData(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 3,
    ),
  );

  // 🌚 Dark Theme
  static final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: AppColors.tealPrimary,
    scaffoldBackgroundColor: AppColors.darkBlueBlack,
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.darkBlueBlack,
      foregroundColor: Colors.white,
      elevation: 0,
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: AppColors.tealPrimary,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.tealPrimary,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    ),
    colorScheme: const ColorScheme.dark(
      primary: AppColors.tealPrimary,
      secondary: AppColors.mintGreen,
      surface: AppColors.darkBlueBlack,
      error: Colors.redAccent,
    ),
    cardTheme: CardThemeData(
      color: const Color(0xFF0E2E3C),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 3,
    ),
  );
}
