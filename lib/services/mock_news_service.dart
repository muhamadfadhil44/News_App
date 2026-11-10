import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:news_app/models/article.dart';
import 'package:news_app/services/news_service.dart';

/// Pilihan simulasi state jaringan untuk pengujian antarmuka pengguna (UI).
/// Digunakan oleh pengembang/siswa untuk memaksa tampilan loading, sukses, error, atau kosong.
enum MockState {
  /// Simulasi pengambilan data berhasil dengan daftar artikel.
  success,

  /// Simulasi kegagalan jaringan atau server (melempar Exception).
  error,

  /// Simulasi respons server yang tidak memiliki data artikel (list kosong).
  empty,
}

/// Implementasi [NewsService] yang menggunakan data lokal dari file JSON contoh.
/// Digunakan selama tahap pengembangan front end untuk mensimulasikan pemanggilan jaringan nyata.
class MockNewsService implements NewsService {
  /// Pengaturan status simulasi untuk memaksa state sukses, error, atau kosong.
  MockState simulatedState;

  /// Durasi jeda buatan untuk mensimulasikan latensi jaringan (default: 1 detik).
  Duration delay;

  /// Asset bundle opsional untuk mempermudah unit testing.
  final AssetBundle? bundle;

  // =========================================================================
  // SAKELAR UTAMA: Di bawah ini di-set ke MockState.error untuk simulasi eror.
  // Jika ingin normal kembali, cukup ganti menjadi MockState.success
  // =========================================================================
  MockNewsService({
    this.simulatedState = MockState.error, 
    this.delay = const Duration(seconds: 1),
    this.bundle,
  });

  AssetBundle get _resolvedBundle => bundle ?? rootBundle;

  @override
  Future<List<Article>> fetchArticles({String? category, String? query}) async {
    // Menggunakan Future.delayed untuk memberikan jeda waktu buatan
    // agar efek visual loading state dapat diamati di antarmuka aplikasi.
    await Future.delayed(delay);

    // 1. Simulasi state Error: Melempar exception layaknya kegagalan koneksi internet atau server
    if (simulatedState == MockState.error) {
      throw Exception('Gagal memuat berita. Terjadi gangguan pada koneksi server simulasi.');
    }

    // 2. Simulasi state Kosong (Empty): Mengembalikan list kosong
    if (simulatedState == MockState.empty) {
      return <Article>[];
    }

    // 3. Simulasi state Sukses: Membaca file JSON contoh dan mem-parsing ke objek Article
    try {
      final String jsonString = await _resolvedBundle.loadString('assets/mock/articles.json');
      final Map<String, dynamic> decodedData = jsonDecode(jsonString) as Map<String, dynamic>;

      final rawArticles = decodedData['articles'] as List<dynamic>? ?? [];
      List<Article> articles = rawArticles
          .map((item) => Article.fromJson(item as Map<String, dynamic>))
          .toList();

      // Menyaring berita berdasarkan kata kunci pencarian (query) jika diberikan
      if (query != null && query.trim().isNotEmpty) {
        final lowerQuery = query.toLowerCase().trim();
        articles = articles.where((article) {
          final titleMatch = article.title.toLowerCase().contains(lowerQuery);
          final descMatch = article.description?.toLowerCase().contains(lowerQuery) ?? false;
          return titleMatch || descMatch;
        }).toList();
      }

      // Menyaring berita berdasarkan kategori jika diberikan (kecuali kategori umum 'semua')
      if (category != null && category.trim().isNotEmpty && category.toLowerCase() != 'semua') {
        final lowerCategory = category.toLowerCase().trim();
        articles = articles.where((article) {
          final titleMatch = article.title.toLowerCase().contains(lowerCategory);
          final descMatch = article.description?.toLowerCase().contains(lowerCategory) ?? false;
          final contentMatch = article.content?.toLowerCase().contains(lowerCategory) ?? false;
          return titleMatch || descMatch || contentMatch;
        }).toList();
      }

      return articles;
    } catch (e) {
      if (e is Exception) {
        rethrow;
      }
      throw Exception('Gagal membaca data artikel contoh: $e');
    }
  }
}
