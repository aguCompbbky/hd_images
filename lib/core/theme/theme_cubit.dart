import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeCubit extends Cubit<ThemeMode> {

  ThemeCubit({required this.sharedPreferences}) : super(_getInitialTheme(sharedPreferences));
  final SharedPreferences sharedPreferences;
  static const _themeKey = 'is_dark_mode';

  static ThemeMode _getInitialTheme(SharedPreferences prefs) {
    final isDarkMode = prefs.getBool(_themeKey);
    if (isDarkMode == null) return ThemeMode.system;
    return isDarkMode ? ThemeMode.dark : ThemeMode.light;
  }

  void toggleTheme() {
    var isDark = false;
    if (state == ThemeMode.dark) {
      isDark = true;
    } else if (state == ThemeMode.system) {
       // Platform brightness fallback checks can be done if needed, 
       // but here we just toggle away from system to explicit modes.
    }
    
    final newMode = isDark ? ThemeMode.light : ThemeMode.dark;
    
    sharedPreferences.setBool(_themeKey, !isDark);
    emit(newMode);
  }

  void setDarkMode(bool isDark) {
    sharedPreferences.setBool(_themeKey, isDark);
    emit(isDark ? ThemeMode.dark : ThemeMode.light);
  }
}
