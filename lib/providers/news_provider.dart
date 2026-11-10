import 'package:flutter/material.dart';
import 'package:news_app/models/article.dart';
import 'package:news_app/services/news_service.dart';

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
///
/// Catatan pembelajaran:
/// - Menggunakan [ChangeNotifier] untuk memberitahu widget pendengar saat ada perubahan data.
/// - Hanya bergantung pada kelas abstrak [NewsService], bukan implementasi langsung.
/// - Memiliki 4 status utama: loading, sukses, error, dan kosong.
class NewsProvider extends ChangeNotifier {
  final NewsService newsService;

  NewsStatus _status = NewsStatus.loading;
  List<Article> _articles = [];
  String _errorMessage = '';

  NewsProvider({required this.newsService});

  // Getter untuk diakses oleh UI
  NewsStatus get status => _status;
  List<Article> get articles => _articles;
  String get errorMessage => _errorMessage;

  bool get isLoading => _status == NewsStatus.loading;
  bool get isSuccess => _status == NewsStatus.success;
  bool get isError => _status == NewsStatus.error;
  bool get isEmpty => _status == NewsStatus.empty;

  /// Memuat daftar artikel secara asinkron menggunakan async/await.
  /// Memperbarui state dan memicu pembaruan UI melalui [notifyListeners].
  Future<void> loadArticles({String? category, String? query}) async {
    // 1. Set status ke loading dan bersihkan pesan error lama
    _status = NewsStatus.loading;
    _errorMessage = '';
    notifyListeners();

    try {
      // 2. Memanggil service secara asinkron (mengembalikan Future)
      final results = await newsService.fetchArticles(
        category: category,
        query: query,
      );

      // 3. Menentukan status sukses atau kosong berdasarkan isi data
      if (results.isEmpty) {
        _status = NewsStatus.empty;
        _articles = [];
      } else {
        _status = NewsStatus.success;
        _articles = results;
      }
    } catch (e) {
      // 4. Menangkap error dan mengubah status ke error
      _status = NewsStatus.error;
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
    } finally {
      // 5. Selalu panggil notifyListeners agar UI membangun ulang tampilannya sesuai status akhir
      notifyListeners();
    }
  }

  /// Memuat ulang data berita (biasanya dipanggil saat aksi pull-to-refresh).
  Future<void> refreshArticles() async {
    await loadArticles();
  }
}
