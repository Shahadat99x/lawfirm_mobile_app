import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../shared/storage/app_prefs.dart';

/// Provides the current locale for the app.
/// null indicates "System Default".
final localeProvider = NotifierProvider<LocaleNotifier, Locale?>(() {
  return LocaleNotifier();
});

class LocaleNotifier extends Notifier<Locale?> {
  @override
  Locale? build() {
    final prefs = ref.read(appPrefsProvider);
    final savedCode = prefs.getLocale();
    if (savedCode != null) {
      return Locale(savedCode);
    }
    return null; // System default
  }

  /// Sets the locale manually. Pass null to use system default.
  Future<void> setLocale(Locale? locale) async {
    state = locale;
    final prefs = ref.read(appPrefsProvider);
    await prefs.setLocale(locale?.languageCode);
  }
}
