import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Single source of truth for Application Configuration.
///
/// Priority of resolution:
/// 1. Dart Environment Variables (--dart-define) - Preferred for Release
/// 2. .env file (flutter_dotenv) - Development fallback
/// 3. Hardcoded Defaults - Last resort / Dev only
class AppConfig {
  static final AppConfig _instance = AppConfig._internal();

  factory AppConfig() => _instance;

  AppConfig._internal();

  // Load from multiple sources
  String get apiBaseUrl =>
      _resolve(key: 'API_BASE_URL', defaultValue: _defaultApiUrl);

  String get adminUrl => _resolve(
    key: 'ADMIN_URL',
    defaultValue: 'https://lexnovaeu.vercel.app/admin/login',
  );

  String get supabaseUrl => _resolve(key: 'SUPABASE_URL', defaultValue: '');

  String get supabaseAnonKey =>
      _resolve(key: 'SUPABASE_ANON_KEY', defaultValue: '');

  String _resolve({required String key, required String defaultValue}) {
    // 1. Try --dart-define (Compile-time / CI / Release)
    // Note: String.fromEnvironment is const-capable but we use it dynamically here
    // to allow fallback logic.
    const fromEnv = String.fromEnvironment(
      '',
    ); // Helper not needed, accessing directly below

    // Check if key exists in environment
    if (const bool.hasEnvironment('API_BASE_URL') && key == 'API_BASE_URL') {
      return const String.fromEnvironment('API_BASE_URL');
    }
    if (const bool.hasEnvironment('ADMIN_URL') && key == 'ADMIN_URL') {
      return const String.fromEnvironment('ADMIN_URL');
    }
    if (const bool.hasEnvironment('SUPABASE_URL') && key == 'SUPABASE_URL') {
      return const String.fromEnvironment('SUPABASE_URL');
    }
    if (const bool.hasEnvironment('SUPABASE_ANON_KEY') &&
        key == 'SUPABASE_ANON_KEY') {
      return const String.fromEnvironment('SUPABASE_ANON_KEY');
    }

    // 2. Try .env (Runtime / Local Dev)
    final dotenvValue = dotenv.env[key];
    if (dotenvValue != null && dotenvValue.isNotEmpty) {
      return dotenvValue;
    }

    // 3. Fallback
    return defaultValue;
  }

  String get _defaultApiUrl {
    // Android emulator localhost
    if (!kIsWeb && Platform.isAndroid) {
      return 'http://10.0.2.2:3000';
    }
    // iOS simulator / Web localhost
    return 'http://localhost:3000';
  }
}
