import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeController extends ChangeNotifier {
  ThemeController({SharedPreferences? preferences})
    : _preferencesFuture = preferences != null
          ? Future<SharedPreferences>.value(preferences)
          : SharedPreferences.getInstance() {
    _loadTheme();
  }

  static const _themeKey = 'theme_mode';

  final Future<SharedPreferences> _preferencesFuture;

  ThemeMode _themeMode = ThemeMode.system;
  ThemeMode get themeMode => _themeMode;

  Future<void> setTheme(ThemeMode mode) async {
    if (_themeMode == mode) return;
    _themeMode = mode;
    notifyListeners();

    final prefs = await _preferencesFuture;
    await prefs.setString(_themeKey, _encodeThemeMode(mode));
  }

  Future<void> _loadTheme() async {
    final prefs = await _preferencesFuture;
    final stored = prefs.getString(_themeKey);
    if (stored == null) return;
    final mode = _decodeThemeMode(stored);
    if (mode == null) return;
    _themeMode = mode;
    notifyListeners();
  }

  String _encodeThemeMode(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.light:
        return 'light';
      case ThemeMode.dark:
        return 'dark';
      case ThemeMode.system:
        return 'system';
    }
  }

  ThemeMode? _decodeThemeMode(String value) {
    switch (value) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      case 'system':
        return ThemeMode.system;
      default:
        return null;
    }
  }
}
