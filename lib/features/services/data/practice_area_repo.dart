import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:lexnova/shared/supabase/supabase_client.dart';
import 'package:lexnova/shared/cache/simple_cache.dart';
import '../domain/practice_area.dart';

final practiceAreasProvider = FutureProvider<List<PracticeArea>>((ref) async {
  final repo = PracticeAreaRepo(ref.watch(supabaseClientProvider));
  return repo.getPracticeAreas();
});

class PracticeAreaRepo {
  final SupabaseClient _client;
  final SimpleCache _cache = SimpleCache();
  static const String _cacheKey = 'practice_areas_cache';

  PracticeAreaRepo(this._client);

  Future<List<PracticeArea>> getPracticeAreas() async {
    try {
      // Try network first
      final response = await _client
          .from('practice_areas')
          .select()
          .order('sort_order', ascending: true);

      final data = List<Map<String, dynamic>>.from(response);
      
      // Update cache
      await _cache.setJson(_cacheKey, data);
      await _cache.setTimestamp(_cacheKey, DateTime.now());
      
      return data.map((e) => PracticeArea.fromMap(e)).toList();
    } catch (e) {
      // If network fails, try cache
      final cachedData = await _cache.getJsonList(_cacheKey);
      if (cachedData != null) {
        return cachedData.map((e) => PracticeArea.fromMap(e)).toList();
      }
      rethrow;
    }
  }
}
