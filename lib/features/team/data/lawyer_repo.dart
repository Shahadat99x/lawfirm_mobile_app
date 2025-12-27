import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:lexnova/shared/supabase/supabase_client.dart';
import 'package:lexnova/shared/cache/simple_cache.dart';
import '../domain/lawyer.dart';

final lawyersProvider = StreamProvider<List<Lawyer>>((ref) {
  final repo = LawyerRepo(ref.watch(supabaseClientProvider));
  return repo.getLawyers();
});

class LawyerRepo {
  final SupabaseClient _client;
  final SimpleCache _cache = SimpleCache();
  static const String _cacheKey = 'lawyers_cache';

  LawyerRepo(this._client);

  Stream<List<Lawyer>> getLawyers() async* {
    // 1. Emit Cache First
    final cachedData = await _cache.getJsonList(_cacheKey);
    if (cachedData != null) {
      yield cachedData.map((e) => Lawyer.fromMap(e)).toList();
    }

    // 2. Fetch Network
    try {
      final response = await _client
          .from('lawyers')
          .select()
          .eq('is_active', true)
          .order('sort_order', ascending: true);

      final data = List<Map<String, dynamic>>.from(response);
      await _cache.setJson(_cacheKey, data);
      await _cache.setTimestamp(_cacheKey, DateTime.now());

      yield data.map((e) => Lawyer.fromMap(e)).toList();
    } catch (e) {
      if (cachedData == null) throw e;
    }
  }

  Future<void> clearCache() => _cache.remove(_cacheKey);
}
