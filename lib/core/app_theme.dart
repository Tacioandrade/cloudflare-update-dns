import 'package:flutter/material.dart';
import 'constants.dart';

class AppThemeController {
  static const String systemValue = 'system';
  static const String lightValue = 'light';
  static const String darkValue = 'dark';

  static final ValueNotifier<ThemeMode> themeMode =
      ValueNotifier(ThemeMode.system);

  static ThemeMode fromStorageValue(String value) {
    switch (value) {
      case lightValue:
        return ThemeMode.light;
      case darkValue:
        return ThemeMode.dark;
      case systemValue:
      default:
        return ThemeMode.system;
    }
  }

  static String toStorageValue(ThemeMode value) {
    switch (value) {
      case ThemeMode.light:
        return lightValue;
      case ThemeMode.dark:
        return darkValue;
      case ThemeMode.system:
        return systemValue;
    }
  }

  static final ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: AppColors.primary,
    scaffoldBackgroundColor: const Color(0xFFF6F7F9),
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.primary,
      brightness: Brightness.light,
    ).copyWith(
      primary: AppColors.primary,
      surface: Colors.white,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.white,
      foregroundColor: Color(0xFF202124),
      elevation: 0,
    ),
    useMaterial3: true,
  );

  static final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: AppColors.primary,
    scaffoldBackgroundColor: AppColors.background,
    colorScheme: const ColorScheme.dark(
      primary: AppColors.primary,
      surface: AppColors.surface,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.surface,
      elevation: 0,
    ),
    useMaterial3: true,
  );
}
