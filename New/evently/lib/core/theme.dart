import 'package:flutter/material.dart';

class AppColors {
  // Light theme
  static const Color lightPrimary = Color(0xFF101127);
  static const Color lightBackground = Colors.white;
  static const Color lightTextPrimary = Colors.black87;
  static const Color lightTextSecondary = Colors.grey;

  // Dark theme
  static const Color darkPrimary = Color(0xFF5669FF);
  static const Color darkBackground = Color(0xFF121212);
  static const Color darkTextPrimary = Colors.white;
  static const Color darkTextSecondary = Colors.grey;
  //   static const Color darkButton = Color(0xFF5669FF);
  // }
}

class AppTextStyles {
  static const TextStyle heading = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.bold,
  );

  static const TextStyle title = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
  );

  static const TextStyle body = TextStyle(fontSize: 16);
}

// Light ThemeData
final ThemeData lightTheme = ThemeData(
  primaryColor: AppColors.lightPrimary,
  scaffoldBackgroundColor: AppColors.lightBackground,
  iconTheme: IconThemeData(color: AppColors.lightTextPrimary),
  appBarTheme: const AppBarTheme(
    backgroundColor: AppColors.lightBackground,
    elevation: 0,
    iconTheme: IconThemeData(color: AppColors.lightTextPrimary),
    titleTextStyle: TextStyle(
      color: AppColors.lightTextPrimary,
      fontWeight: FontWeight.bold,
      fontSize: 20,
    ),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: AppColors.lightPrimary, // your light theme primary
      foregroundColor: Colors.white, // text color
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    ),
  ),
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: AppColors.lightPrimary,
  ),
  switchTheme: SwitchThemeData(
    thumbColor: MaterialStateProperty.all(AppColors.lightPrimary),
  ),
  textTheme: const TextTheme(
    bodyMedium: TextStyle(color: AppColors.lightTextPrimary),
    bodySmall: TextStyle(color: AppColors.lightTextSecondary),
  ),
);

// Dark ThemeData
final ThemeData darkTheme = ThemeData(
  primaryColor: AppColors.darkPrimary,
  scaffoldBackgroundColor: AppColors.darkBackground,
  iconTheme: IconThemeData(color: AppColors.darkTextPrimary),
  appBarTheme: const AppBarTheme(
    backgroundColor: AppColors.darkBackground,
    elevation: 0,
    iconTheme: IconThemeData(color: AppColors.darkTextPrimary),
    titleTextStyle: TextStyle(
      color: AppColors.darkTextPrimary,
      fontWeight: FontWeight.bold,
      fontSize: 20,
    ),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: AppColors.darkPrimary, // your dark theme primary
      foregroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    ),
  ),
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: AppColors.darkPrimary,
  ),
  switchTheme: SwitchThemeData(
    thumbColor: MaterialStateProperty.all(AppColors.darkPrimary),
  ),
  textTheme: const TextTheme(
    bodyMedium: TextStyle(color: AppColors.darkTextPrimary),
    bodySmall: TextStyle(color: AppColors.darkTextSecondary),
  ),
);
