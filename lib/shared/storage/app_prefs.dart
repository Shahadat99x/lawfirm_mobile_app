import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Provider that will be overridden in main.dart
final appPrefsProvider = Provider<AppPrefs>((ref) {
  throw UnimplementedError('AppPrefs not initialized');
});

class AppPrefs {
  final SharedPreferences _prefs;

  AppPrefs(this._prefs);

  static const String _keyOnboardingSeen = 'onboarding_seen';

  bool get onboardingSeen => _prefs.getBool(_keyOnboardingSeen) ?? false;

  Future<void> setOnboardingSeen() async {
    await _prefs.setBool(_keyOnboardingSeen, true);
  }

  static const String _keyLocale = 'app_locale';

  /// Returns saved locale code (e.g. 'en', 'lt') or null if system default
  String? getLocale() {
    return _prefs.getString(_keyLocale);
  }

  /// Saves locale code, or removes key if null (system default)
  Future<void> setLocale(String? languageCode) async {
    if (languageCode == null) {
      await _prefs.remove(_keyLocale);
    } else {
      await _prefs.setString(_keyLocale, languageCode);
    }
  }
}
