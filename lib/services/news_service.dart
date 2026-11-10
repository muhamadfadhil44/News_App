import 'package:news_app/models/article.dart';

/// Kelas abstrak NewsService sebagai kontrak utama pengambilan data berita.
/// Sesuai arsitektur PRD:
/// - UI dan Provider hanya bergantung pada kelas abstrak ini, bukan implementasi langsung.
/// - Pada tahap front end, implementasi yang digunakan adalah [MockNewsService].
/// - Pada tahap integrasi API, siswa dapat membuat [ApiNewsService] yang mengimplementasikan kelas ini
///   tanpa perlu mengubah kode pada antarmuka (UI).
abstract class NewsService {
  /// Mengambil daftar artikel berita secara asinkron.
  ///
  /// Mengembalikan [Future] berisi daftar objek [Article].
  /// Parameter opsional:
  /// - [category]: Menyaring berita berdasarkan kategori tertentu.
  /// - [query]: Menyaring berita berdasarkan kata kunci pencarian.
  Future<List<Article>> fetchArticles({String? category, String? query});
}
