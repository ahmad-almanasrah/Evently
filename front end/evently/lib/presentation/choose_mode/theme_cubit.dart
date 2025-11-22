import 'package:flutter/material.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

// 1. Use HydratedCubit to save state automatically
class ThemeCubit extends HydratedCubit<ThemeMode> {
  // Default to System setting (or ThemeMode.light)
  ThemeCubit() : super(ThemeMode.system);

  // Toggle between light and dark
  void toggleTheme() {
    emit(state == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark);
  }

  // --- PERSISTENCE CODE ---
  @override
  ThemeMode? fromJson(Map<String, dynamic> json) {
    // Load saved theme from disk
    return ThemeMode.values[json['theme_mode'] as int];
  }

  @override
  Map<String, dynamic>? toJson(ThemeMode state) {
    // Save theme to disk
    return {'theme_mode': state.index};
  }
}
