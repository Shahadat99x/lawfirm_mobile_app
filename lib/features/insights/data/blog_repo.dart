import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:lexnova/shared/supabase/supabase_client.dart';
import 'package:lexnova/shared/cache/simple_cache.dart';
import '../domain/blog_post.dart';

final blogPostsProvider = StreamProvider<List<BlogPost>>((ref) {
  final repo = BlogRepo(ref.watch(supabaseClientProvider));
  return repo.getBlogPosts();
});

class BlogRepo {
  final SupabaseClient _client;
  final SimpleCache _cache = SimpleCache();
  static const String _cacheKey = 'blog_posts_cache';

  BlogRepo(this._client);

  Stream<List<BlogPost>> getBlogPosts() async* {
    // 1. Emit Cache First
    final cachedData = await _cache.getJsonList(_cacheKey);
    if (cachedData != null) {
      yield cachedData.map((e) => BlogPost.fromMap(e)).toList();
    }

    // 2. Fetch Network
    try {
      final response = await _client
          .from('blog_posts')
          .select()
          .eq('status', 'published')
          .order('published_at', ascending: false);

      final data = List<Map<String, dynamic>>.from(response);
      await _cache.setJson(_cacheKey, data);
      await _cache.setTimestamp(_cacheKey, DateTime.now());

      yield data.map((e) => BlogPost.fromMap(e)).toList();
    } catch (e) {
      if (cachedData == null) throw e;
    }
  }

  Future<void> clearCache() => _cache.remove(_cacheKey);
}
