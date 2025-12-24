import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:lexnova/shared/supabase/supabase_client.dart';
import 'package:lexnova/shared/cache/simple_cache.dart';
import '../domain/lawyer.dart';

final lawyersProvider = FutureProvider<List<Lawyer>>((ref) async {
  final repo = LawyerRepo(ref.watch(supabaseClientProvider));
  return repo.getLawyers();
});

class LawyerRepo {
  final SupabaseClient _client;
  final SimpleCache _cache = SimpleCache();
  static const String _cacheKey = 'lawyers_cache';

  LawyerRepo(this._client);

  Future<List<Lawyer>> getLawyers() async {
    try {
      final response = await _client
          .from('lawyers')
          .select()
          .eq('is_active', true)
          .order('sort_order', ascending: true);

      final data = List<Map<String, dynamic>>.from(response);
      await _cache.setJson(_cacheKey, data);
      await _cache.setTimestamp(_cacheKey, DateTime.now());
      
      return data.map((e) => Lawyer.fromMap(e)).toList();
    } catch (e) {
      final cachedData = await _cache.getJsonList(_cacheKey);
      if (cachedData != null) {
        return cachedData.map((e) => Lawyer.fromMap(e)).toList();
      }
      rethrow;
    }
  }
}
