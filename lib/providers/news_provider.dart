import 'package:flutter/material.dart';
import 'package:news_app/models/article.dart';
import 'package:news_app/services/news_service.dart';
import 'package:news_app/services/news_exception.dart';

/// Empat status kondisi jaringan sesuai arsitektur PRD.
/// Menggambarkan alur state: loading -> sukses / error / kosong.
enum NewsStatus {
  /// Sedang mengambil/memuat data dari service.
  loading,

  /// Data berhasil dimuat dan daftar artikel tidak kosong.
  success,

  /// Terjadi kesalahan atau gangguan koneksi saat memuat data.
  error,

  /// Permintaan berhasil tetapi tidak ada artikel yang ditemukan (data kosong).
  empty,
}

/// Provider pengelola state berita dan status jaringan.
class NewsProvider extends ChangeNotifier {
  final NewsService newsService;

  NewsStatus _status = NewsStatus.loading;
  List<Article> _articles = [];
  String _errorMessage = '';
  String _selectedCategory = 'Semua';
  String _searchQuery = '';

  NewsProvider({required this.newsService});

  // Getter untuk diakses oleh UI
  NewsStatus get status => _status;
  List<Article> get articles => _articles;
  String get errorMessage => _errorMessage;
  String get selectedCategory => _selectedCategory;
  String get searchQuery => _searchQuery;

  bool get isLoading => _status == NewsStatus.loading;
  bool get isSuccess => _status == NewsStatus.success;
  bool get isError => _status == NewsStatus.error;
  bool get isEmpty => _status == NewsStatus.empty;

  /// Mengubah kategori aktif dan memuat ulang data sesuai kategori terpilih.
  void setCategory(String category) {
    if (_selectedCategory == category) return;
    _selectedCategory = category;
    loadArticles(
      category: _selectedCategory,
      query: _searchQuery,
    );
  }

  /// Melakukan pencarian berdasarkan kata kunci query.
  void setSearchQuery(String query) {
    _searchQuery = query;
    loadArticles(
      category: _selectedCategory,
      query: _searchQuery,
    );
  }

  /// Menghapus kata kunci pencarian dan kembali ke daftar kategori aktif.
  void clearSearch() {
    _searchQuery = '';
    loadArticles(
      category: _selectedCategory,
      query: '',
    );
  }

  /// Memuat daftar artikel secara asinkron menggunakan async/await.
  /// Memperbarui state dan memicu pembaruan UI melalui [notifyListeners].
  Future<void> loadArticles({String? category, String? query}) async {
    final activeCategory = category ?? _selectedCategory;
    final activeQuery = query ?? _searchQuery;

    // 1. Set status ke loading dan bersihkan pesan error lama (Sesuai Kode 5)
    _status = NewsStatus.loading;
    _errorMessage = '';
    notifyListeners();

    try {
      // 2. Memanggil service secara asinkron
      _articles = await newsService.fetchArticles(
        category: activeCategory,
        query: activeQuery,
      );

      // 3. Menentukan status sukses atau kosong berdasarkan isi data (Sesuai Kode 5)
      _status = _articles.isEmpty ? NewsStatus.empty : NewsStatus.success;

    } on NewsException catch (e) {
      // 4. Menangkap NewsException dengan membawa pesan khusus dari server (Sesuai Kode 5)
      _errorMessage = e.message;
      _status = NewsStatus.error;

    } catch (_) {
      // 5. Menangkap error lainnya (tidak ada internet/timeout) dengan pesan umum (Sesuai Kode 5)
      _errorMessage = 'Gagal terhubung. Periksa koneksi internetmu.';
      _status = NewsStatus.error;

    } finally {
      // 6. Selalu panggil notifyListeners agar UI membangun ulang tampilannya
      notifyListeners();
    }
  }

  /// Memuat ulang data berita (biasanya dipanggil saat aksi pull-to-refresh).
  Future<void> refreshArticles() async {
    await loadArticles(
      category: _selectedCategory,
      query: _searchQuery,
    );
  }
}
