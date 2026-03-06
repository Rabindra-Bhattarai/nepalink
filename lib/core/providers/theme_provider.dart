import 'package:flutter/material.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _kThemeKey = 'theme_mode';
const _kLightSensorEnabled = 'light_sensor_auto_theme';

final themeModeProvider = StateNotifierProvider<ThemeModeNotifier, ThemeMode>(
  (ref) => ThemeModeNotifier(),
);

class ThemeModeNotifier extends StateNotifier<ThemeMode> {
  ThemeModeNotifier() : super(ThemeMode.light) {
    _loadSavedTheme();
  }

  Future<void> _loadSavedTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getString(_kThemeKey);
    if (saved == 'dark') {
      state = ThemeMode.dark;
    } else {
      state = ThemeMode.light;
    }
  }

  /// Manual toggle from profile screen dark mode switch
  Future<void> toggle() async {
    state = state == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    await _save();
  }

  /// Called by light sensor — sets theme based on lux value
  /// < 10 lux = very dark room → dark mode
  /// >= 10 lux = normal/bright light → light mode
  Future<void> setFromLux(double lux) async {
    final newMode = lux < 10.0 ? ThemeMode.dark : ThemeMode.light;
    if (newMode != state) {
      state = newMode;
      await _save();
    }
  }

  Future<void> setDark() async {
    if (state != ThemeMode.dark) {
      state = ThemeMode.dark;
      await _save();
    }
  }

  Future<void> setLight() async {
    if (state != ThemeMode.light) {
      state = ThemeMode.light;
      await _save();
    }
  }

  Future<void> _save() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      _kThemeKey,
      state == ThemeMode.dark ? 'dark' : 'light',
    );
  }
}

// ── Light sensor auto-theme enabled flag ─────────────────────────────────────
final lightSensorEnabledProvider =
    StateNotifierProvider<LightSensorEnabledNotifier, bool>(
      (ref) => LightSensorEnabledNotifier(),
    );

class LightSensorEnabledNotifier extends StateNotifier<bool> {
  LightSensorEnabledNotifier() : super(false) {
    _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    state = prefs.getBool(_kLightSensorEnabled) ?? false;
  }

  Future<void> toggle() async {
    state = !state;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_kLightSensorEnabled, state);
  }

  Future<void> setEnabled(bool value) async {
    state = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_kLightSensorEnabled, value);
  }
}
