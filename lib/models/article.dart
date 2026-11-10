/// Model data untuk artikel berita.
/// Sesuai PRD:
/// - Memiliki properti: sourceName, author, title, description, url, urlToImage, publishedAt, content.
/// - Semua field boleh bernilai null kecuali `title`.
class Article {
  final String? sourceName;
  final String? author;
  final String title;
  final String? description;
  final String? url;
  final String? urlToImage;
  final String? publishedAt;
  final String? content;

  const Article({
    this.sourceName,
    this.author,
    required this.title,
    this.description,
    this.url,
    this.urlToImage,
    this.publishedAt,
    this.content,
  });

  /// Mengonversi Map JSON dari respons API/data mock menjadi objek [Article].
  ///
  /// Catatan pembelajaran:
  /// - Field 'source' pada NewsAPI berupa objek JSON `{"id": "...", "name": "..."}`.
  /// - Field 'title' adalah satu-satunya field wajib, jika kosong diberikan teks pengganti 'Tanpa Judul'.
  /// - Semua field lainnya boleh null (nullable) dan ditangani dengan aman agar tidak terjadi error runtime.
  factory Article.fromJson(Map<String, dynamic> json) {
    // Mengambil nama sumber berita dari objek bertingkat 'source'
    String? parsedSourceName;
    final sourceField = json['source'];
    if (sourceField is Map<String, dynamic>) {
      parsedSourceName = sourceField['name'] as String?;
    } else if (sourceField is String) {
      parsedSourceName = sourceField;
    }

    // Mengambil judul dengan fallback jika bernilai null atau string kosong
    final rawTitle = json['title'] as String?;
    final String resolvedTitle =
        (rawTitle != null && rawTitle.trim().isNotEmpty)
            ? rawTitle
            : 'Tanpa Judul';

    return Article(
      sourceName: parsedSourceName,
      author: json['author'] as String?,
      title: resolvedTitle,
      description: json['description'] as String?,
      url: json['url'] as String?,
      urlToImage: json['urlToImage'] as String?,
      publishedAt: json['publishedAt'] as String?,
      content: json['content'] as String?,
    );
  }

  /// Mengonversi objek [Article] ke bentuk Map JSON (membantu saat pengujian atau serialisasi).
  Map<String, dynamic> toJson() {
    return {
      'source': sourceName != null ? {'name': sourceName} : null,
      'author': author,
      'title': title,
      'description': description,
      'url': url,
      'urlToImage': urlToImage,
      'publishedAt': publishedAt,
      'content': content,
    };
  }

  /// Operator kesetaraan untuk membandingkan dua artikel berdasarkan url atau judulnya.
  /// Mempermudah pengecekan bookmark dan pengujian.
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Article &&
          runtimeType == other.runtimeType &&
          ((url != null && other.url != null)
              ? url == other.url
              : title == other.title);

  @override
  int get hashCode => (url ?? title).hashCode;

  @override
  String toString() => 'Article(title: $title, sourceName: $sourceName)';
}
