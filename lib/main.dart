import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'app/app.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:lexnova/shared/storage/app_prefs.dart';
import 'package:lexnova/shared/config/app_config.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load environment variables
  bool envLoaded = false;
  try {
    await dotenv.load(fileName: ".env");
    envLoaded = true;
  } catch (e) {
    debugPrint("Warning: .env file not found. Using defaults.");
  }

  // Initialize Supabase
  final appConfig = AppConfig();
  final supabaseUrl = appConfig.supabaseUrl;
  final supabaseAnonKey = appConfig.supabaseAnonKey;

  if (supabaseUrl.isNotEmpty && supabaseAnonKey.isNotEmpty) {
    await Supabase.initialize(url: supabaseUrl, anonKey: supabaseAnonKey);
  } else {
    debugPrint("Warning: Supabase keys not found in Environment or .env");
  }

  final prefs = await SharedPreferences.getInstance();

  runApp(
    ProviderScope(
      overrides: [appPrefsProvider.overrideWithValue(AppPrefs(prefs))],
      child: const LexNovaApp(),
    ),
  );
}
