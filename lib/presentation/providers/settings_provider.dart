import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsState {
  final Locale locale;
  final ThemeMode themeMode;

  const SettingsState({
    required this.locale,
    required this.themeMode,
  });

  SettingsState copyWith({
    Locale? locale,
    ThemeMode? themeMode,
  }) {
    return SettingsState(
      locale: locale ?? this.locale,
      themeMode: themeMode ?? this.themeMode,
    );
  }
}

class SettingsNotifier extends StateNotifier<SettingsState> {
  static const String _localeKey = 'addiscan_pref_locale';
  static const String _themeKey = 'addiscan_pref_theme';

  SettingsNotifier()
      : super(SettingsState(
          locale: _detectInitialLocale(),
          themeMode: ThemeMode.light,
        )) {
    _loadFromPrefs();
  }

  static Locale _detectInitialLocale() {
    final deviceLocale = ui.PlatformDispatcher.instance.locale;
    final code = deviceLocale.languageCode.toLowerCase();
    if (code == 'fr') return const Locale('fr');
    if (code == 'ar') return const Locale('ar');
    return const Locale('en');
  }

  Future<void> _loadFromPrefs() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final langCode = prefs.getString(_localeKey);
      final themeStr = prefs.getString(_themeKey);

      Locale loc = state.locale;
      if (langCode != null) {
        loc = Locale(langCode);
      }

      ThemeMode mode = ThemeMode.light;
      if (themeStr == 'dark') {
        mode = ThemeMode.dark;
      } else if (themeStr == 'system') {
        mode = ThemeMode.system;
      }

      state = state.copyWith(locale: loc, themeMode: mode);
    } catch (_) {}
  }

  Future<void> setLocale(Locale newLocale) async {
    state = state.copyWith(locale: newLocale);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_localeKey, newLocale.languageCode);
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    state = state.copyWith(themeMode: mode);
    final prefs = await SharedPreferences.getInstance();
    String modeStr = 'light';
    if (mode == ThemeMode.dark) modeStr = 'dark';
    if (mode == ThemeMode.system) modeStr = 'system';
    await prefs.setString(_themeKey, modeStr);
  }
}

final settingsNotifierProvider =
    StateNotifierProvider<SettingsNotifier, SettingsState>((ref) {
  return SettingsNotifier();
});
