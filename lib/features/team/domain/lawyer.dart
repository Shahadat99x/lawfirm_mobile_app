class Lawyer {
  final String id;
  final String name;
  final String title;
  final String slug;
  final String? bio;
  final List<String>? languages;
  final String? photoUrl;
  final bool isActive;
  final int sortOrder;

  Lawyer({
    required this.id,
    required this.name,
    required this.title,
    required this.slug,
    this.bio,
    this.languages,
    this.photoUrl,
    required this.isActive,
    required this.sortOrder,
  });

  factory Lawyer.fromMap(Map<String, dynamic> map) {
    return Lawyer(
      id: map['id'] as String,
      name: map['name'] as String,
      title: map['title'] as String,
      slug: map['slug'] as String,
      bio: map['bio'] as String?,
      languages: (map['languages'] as List<dynamic>?)?.map((e) => e as String).toList(),
      photoUrl: map['photo_url'] as String?,
      isActive: map['is_active'] as bool? ?? true,
      sortOrder: map['sort_order'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'title': title,
      'slug': slug,
      'bio': bio,
      'languages': languages,
      'photo_url': photoUrl,
      'is_active': isActive,
      'sort_order': sortOrder,
    };
  }
}
