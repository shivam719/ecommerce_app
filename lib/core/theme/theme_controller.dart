import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// ThemeController manages switching between Light Mode and Dark (Night) Mode
/// across the entire app using GetX reactively.
class ThemeController extends GetxController {
  // RxBool to track whether dark mode is currently enabled
  final RxBool _isDarkMode = false.obs;

  bool get isDarkMode => _isDarkMode.value;

  /// Returns current ThemeMode
  ThemeMode get themeMode => _isDarkMode.value ? ThemeMode.dark : ThemeMode.light;

  /// Toggles theme between Light and Dark mode
  void toggleTheme() {
    _isDarkMode.value = !_isDarkMode.value;
    Get.changeThemeMode(_isDarkMode.value ? ThemeMode.dark : ThemeMode.light);
  }

  /// Explicitly set dark or light theme
  void setThemeMode(bool isDark) {
    _isDarkMode.value = isDark;
    Get.changeThemeMode(isDark ? ThemeMode.dark : ThemeMode.light);
  }
}
