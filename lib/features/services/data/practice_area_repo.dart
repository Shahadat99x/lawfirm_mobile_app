import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:lexnova/shared/supabase/supabase_client.dart';
import 'package:lexnova/shared/cache/simple_cache.dart';
import '../domain/practice_area.dart';

final practiceAreasProvider = StreamProvider<List<PracticeArea>>((ref) {
  final repo = PracticeAreaRepo(ref.watch(supabaseClientProvider));
  return repo.getPracticeAreas();
});

class PracticeAreaRepo {
  final SupabaseClient _client;
  final SimpleCache _cache = SimpleCache();
  static const String _cacheKey = 'practice_areas_cache';

  PracticeAreaRepo(this._client);

  Stream<List<PracticeArea>> getPracticeAreas() async* {
    // 1. Emit Cache First (if available)
    final cachedData = await _cache.getJsonList(_cacheKey);
    if (cachedData != null) {
      yield cachedData.map((e) => PracticeArea.fromMap(e)).toList();
    }

    // 2. Fetch Network
    try {
      final response = await _client
          .from('practice_areas')
          .select()
          .order('sort_order', ascending: true);

      final data = List<Map<String, dynamic>>.from(response);

      // Update cache
      await _cache.setJson(_cacheKey, data);
      await _cache.setTimestamp(_cacheKey, DateTime.now());

      yield data.map((e) => PracticeArea.fromMap(e)).toList();
    } catch (e) {
      // If we already yielded cache, we just suppress the error for "offline mode"
      // unless we want to let the UI know via a snackbar or valid-but-stale state.
      // But StreamProvider will just terminate if we don't yield (so last value persists).
      // If no cache was yielded, we must rethrow to show error state.
      if (cachedData == null) {
        throw e;
      }
      // If cachedData exists, we do nothing -> Stream ends -> Provider keeps last value (cache).
      // But we might want to log it.
    }
  }

  Future<void> clearCache() => _cache.remove(_cacheKey);
}
