class PracticeArea {
  final String id;
  final String title;
  final String slug;
  final String? excerpt;
  final String? content;
  final String? icon;
  final int sortOrder;

  PracticeArea({
    required this.id,
    required this.title,
    required this.slug,
    this.excerpt,
    this.content,
    this.icon,
    required this.sortOrder,
  });

  factory PracticeArea.fromMap(Map<String, dynamic> map) {
    return PracticeArea(
      id: map['id'] as String,
      title: map['title'] as String,
      slug: map['slug'] as String,
      excerpt: map['excerpt'] as String?,
      content: map['content'] as String?,
      icon: map['icon'] as String?,
      sortOrder: map['sort_order'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'slug': slug,
      'excerpt': excerpt,
      'content': content,
      'icon': icon,
      'sort_order': sortOrder,
    };
  }
}
