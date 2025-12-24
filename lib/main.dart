import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'app/app.dart';

void main() async {
  print('--- ANTIGRAVITY: DATA INIT START ---');
  WidgetsFlutterBinding.ensureInitialized();
  
  try {
    print('--- ANTIGRAVITY: DATA INIT START ---');
    try {
      print('--- ANTIGRAVITY: LOADING DOTENV FROM env ---');
      await dotenv.load(fileName: "env");
      print('--- ANTIGRAVITY: DOTENV LOADED ---');
    } catch (e) {
      print('--- ANTIGRAVITY: DOTENV ERROR: $e ---');
      // Fallback: try loading just 'env' or '.env' if bundled differently
      try {
         await dotenv.load(fileName: ".env");
      } catch (_) {
         throw Exception('Failed to load configuration. Make sure "env" exists and is in pubspec.yaml. Original Error: $e');
      }
    }

    final supabaseUrl = dotenv.env['SUPABASE_URL'];
    final supabaseAnonKey = dotenv.env['SUPABASE_ANON_KEY'];

    print('Debug Keys: URL=${supabaseUrl != null}, KEY=${supabaseAnonKey != null}');

    if (supabaseUrl == null || supabaseUrl.isEmpty) {
      throw Exception('SUPABASE_URL not found in .env');
    }
    if (supabaseAnonKey == null || supabaseAnonKey.isEmpty) {
      throw Exception('SUPABASE_ANON_KEY not found in .env');
    }

    await Supabase.initialize(
      url: supabaseUrl,
      anonKey: supabaseAnonKey,
    );
    print('--- ANTIGRAVITY: SUPABASE INITIALIZED ---');

    runApp(const ProviderScope(child: LexNovaApp()));
  } catch (error, stackTrace) {
    print('--- CRITICAL INIT ERROR: $error ---');
    print(stackTrace);
    runApp(
      MaterialApp(
        home: Scaffold(
          backgroundColor: Colors.red.shade100,
          body: Center(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: SelectableText(
                'Initialization Failed:\n$error',
                style: const TextStyle(color: Colors.red, fontSize: 18),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
