class BlogPost {
  final String id;
  final String title;
  final String slug;
  final String? excerpt;
  final String? content;
  final String? coverImageUrl;
  final String? category;
  final DateTime? publishedAt;
  final String? authorName;

  BlogPost({
    required this.id,
    required this.title,
    required this.slug,
    this.excerpt,
    this.content,
    this.coverImageUrl,
    this.category,
    this.publishedAt,
    this.authorName,
  });

  factory BlogPost.fromMap(Map<String, dynamic> map) {
    return BlogPost(
      id: map['id'] as String,
      title: map['title'] as String,
      slug: map['slug'] as String,
      excerpt: map['excerpt'] as String?,
      content: map['content'] as String?,
      coverImageUrl: map['cover_image_url'] as String?,
      category: map['category'] as String?,
      publishedAt: map['published_at'] != null ? DateTime.parse(map['published_at']) : null,
      authorName: map['author_name'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'slug': slug,
      'excerpt': excerpt,
      'content': content,
      'cover_image_url': coverImageUrl,
      'category': category,
      'published_at': publishedAt?.toIso8601String(),
      'author_name': authorName,
    };
  }
}
