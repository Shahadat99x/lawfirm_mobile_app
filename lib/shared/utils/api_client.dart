import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiClient {
  static final ApiClient _instance = ApiClient._internal();
  late final Dio _dio;

  factory ApiClient() {
    return _instance;
  }

  ApiClient._internal() {
    // Determine Base URL
    // 1. Try .env
    // 2. Fallback based on Platform
    String? envUrl = dotenv.env['API_BASE_URL'];
    String baseUrl;

    if (envUrl != null && envUrl.isNotEmpty) {
      baseUrl = envUrl;
    } else {
      // Default fallbacks if not set in .env
      if (!kIsWeb && Platform.isAndroid) {
        baseUrl = 'http://10.0.2.2:3000';
      } else {
        baseUrl = 'http://localhost:3000';
      }
    }

    _dio = Dio(BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ));

    if (kDebugMode) {
      _dio.interceptors.add(LogInterceptor(
        requestBody: true,
        responseBody: true,
      ));
    }
  }

  Dio get client => _dio;
}
