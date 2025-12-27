import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class SimpleCache {
  static const Duration _defaultTtl = Duration(hours: 12);

  Future<void> setJson(String key, Object value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, jsonEncode(value));
  }

  Future<Map<String, dynamic>?> getJson(String key) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(key);
    if (jsonString == null) return null;
    try {
      return jsonDecode(jsonString) as Map<String, dynamic>;
    } catch (e) {
      return null;
    }
  }

  Future<List<Map<String, dynamic>>?> getJsonList(String key) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(key);
    if (jsonString == null) return null;
    try {
      final List<dynamic> list = jsonDecode(jsonString);
      return list.cast<Map<String, dynamic>>();
    } catch (e) {
      return null;
    }
  }

  Future<void> setTimestamp(String key, DateTime value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('${key}_timestamp', value.toIso8601String());
  }

  Future<DateTime?> getTimestamp(String key) async {
    final prefs = await SharedPreferences.getInstance();
    final tsString = prefs.getString('${key}_timestamp');
    if (tsString == null) return null;
    try {
      return DateTime.parse(tsString);
    } catch (e) {
      return null;
    }
  }

  Future<bool> isValid(String key) async {
    final ts = await getTimestamp(key);
    if (ts == null) return false;
    return DateTime.now().difference(ts) < _defaultTtl;
  }

  Future<void> remove(String key) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(key);
    await prefs.remove('${key}_timestamp');
  }

  Future<void> clearAll(List<String> keys) async {
    for (final key in keys) {
      await remove(key);
    }
  }
}
