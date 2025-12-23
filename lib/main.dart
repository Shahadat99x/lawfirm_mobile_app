import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'app/app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Load environment variables
  // Note: fileName: ".env" is default, but explicit for clarity
  try {
    await dotenv.load(fileName: ".env");
  } catch (e) {
    // Fallback if .env is missing (e.g. in CI or first run)
    debugPrint("Warning: .env file not found. Using defaults.");
  }

  runApp(const ProviderScope(child: LexNovaApp()));
}
