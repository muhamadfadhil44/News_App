import 'package:flutter/material.dart';
import 'package:news_app/models/article.dart';

/// Provider untuk mengelola status bookmark (artikel favorit) di memori aplikasi.
///
/// Catatan pembelajaran:
/// - Sesuai batasan PRD versi 1, bookmark disimpan di dalam RAM (memori),
///   sehingga daftar favorit akan kembali kosong saat aplikasi ditutup / restart.
/// - Menggunakan [ChangeNotifier] untuk menyiarkan perubahan state
///   ke layar Beranda, Detail, dan Favorit melalui [notifyListeners].
class BookmarkProvider extends ChangeNotifier {
  /// Daftar artikel yang disimpan sebagai favorit di memori.
  final List<Article> _bookmarkedArticles = [];

  /// Getter publik yang mengembalikan salinan list yang tidak dapat dimodifikasi langsung.
  List<Article> get bookmarkedArticles => List.unmodifiable(_bookmarkedArticles);

  /// Memeriksa apakah suatu artikel sudah ada di dalam daftar favorit.
  /// Memanfaatkan kesetaraan objek (operator ==) pada model Article.
  bool isBookmarked(Article article) {
    return _bookmarkedArticles.contains(article);
  }

  /// Menambah atau menghapus artikel dari favorit (toggle).
  /// Mengembalikan nilai boolean `true` jika ditambahkan, atau `false` jika dilepas.
  bool toggleBookmark(Article article) {
    final exists = isBookmarked(article);

    if (exists) {
      _bookmarkedArticles.remove(article);
    } else {
      _bookmarkedArticles.add(article);
    }

    // Memberitahu seluruh widget pendengar bahwa data bookmark telah berubah
    notifyListeners();
    return !exists;
  }

  /// Menambahkan artikel ke daftar favorit jika belum ada.
  void addBookmark(Article article) {
    if (!isBookmarked(article)) {
      _bookmarkedArticles.add(article);
      notifyListeners();
    }
  }

  /// Menghapus artikel dari daftar favorit.
  void removeBookmark(Article article) {
    if (isBookmarked(article)) {
      _bookmarkedArticles.remove(article);
      notifyListeners();
    }
  }
}
