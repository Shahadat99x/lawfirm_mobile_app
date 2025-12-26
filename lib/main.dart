import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'app/app.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:lexnova/shared/storage/app_prefs.dart';

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
  String supabaseUrl = '';
  String supabaseAnonKey = '';

  if (envLoaded) {
    supabaseUrl = dotenv.env['SUPABASE_URL'] ?? '';
    supabaseAnonKey = dotenv.env['SUPABASE_ANON_KEY'] ?? '';
  }

  if (supabaseUrl.isNotEmpty && supabaseAnonKey.isNotEmpty) {
    await Supabase.initialize(
      url: supabaseUrl,
      anonKey: supabaseAnonKey,
    );
  } else {
    debugPrint("Warning: Supabase keys not found in .env or .env missing");
  }

  final prefs = await SharedPreferences.getInstance();

  runApp(
    ProviderScope(
      overrides: [
        appPrefsProvider.overrideWithValue(AppPrefs(prefs)),
      ],
      child: const LexNovaApp(),
    ),
  );
}
