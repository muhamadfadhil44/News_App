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

  MockNewsService({
    this.simulatedState = MockState.success,
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
      String jsonString;
      try {
        jsonString = await _resolvedBundle.loadString('assets/mock/articles.json');
      } catch (_) {
        // Fallback jika aset belum selesai di-bundle oleh compiler/hot reload Flutter
        jsonString = _fallbackJsonString;
      }

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
          final title = article.title.toLowerCase();
          final desc = article.description?.toLowerCase() ?? '';
          final content = article.content?.toLowerCase() ?? '';
          final fullText = '$title $desc $content';

          if (lowerCategory == 'bisnis') {
            return fullText.contains('bisnis') ||
                fullText.contains('ekonomi') ||
                fullText.contains('anggaran') ||
                fullText.contains('investor');
          } else if (lowerCategory == 'olahraga') {
            return fullText.contains('olahraga') ||
                fullText.contains('bulu tangkis') ||
                fullText.contains('turnamen') ||
                fullText.contains('pertandingan');
          } else if (lowerCategory == 'teknologi') {
            return fullText.contains('teknologi') ||
                fullText.contains('satelit') ||
                fullText.contains('digital') ||
                fullText.contains('komputasi');
          } else if (lowerCategory == 'pendidikan') {
            return fullText.contains('kurikulum') ||
                fullText.contains('sekolah') ||
                fullText.contains('pembelajaran');
          }
          return fullText.contains(lowerCategory);
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

  /// Data cadangan (fallback) berformat sama dengan assets/mock/articles.json.
  /// Mencegah terjadinya error 'Unable to load asset' ketika pengembang/siswa
  /// melakukan Hot Reload tanpa melakukan restart penuh aplikasi (Hot Restart/Rebuild).
  static const String _fallbackJsonString = '''
{
  "status": "ok",
  "totalResults": 5,
  "articles": [
    {
      "source": {
        "id": "antaranews",
        "name": "Antara News"
      },
      "author": "Budi Santoso",
      "title": "Peluncuran Satelit Komunikasi Terbaru Berjalan Sukses di Kourou",
      "description": "Satelit komunikasi generasi terbaru berhasil diluncurkan ke orbit geostasioner untuk memperkuat akses internet pelosok.",
      "url": "https://example.com/satelit-komunikasi-sukses",
      "urlToImage": "https://picsum.photos/seed/satelit/600/400",
      "publishedAt": "2026-10-13T08:30:00Z",
      "content": "Peluncuran roket pembawa satelit komunikasi berjalan mulus tanpa kendala teknis. Satelit ini diharapkan mulai beroperasi penuh bulan depan."
    },
    {
      "source": {
        "id": "kompas",
        "name": "Kompas"
      },
      "author": null,
      "title": "Pemerintah Tingkatkan Anggaran Energi Terbarukan untuk Target Emisi Nol",
      "description": "Pemerintah mengumumkan kenaikan alokasi pendanaan proyek tenaga surya dan bayu nasional.",
      "url": "https://example.com/anggaran-energi-terbarukan",
      "urlToImage": "https://picsum.photos/seed/energi/600/400",
      "publishedAt": "2026-10-13T09:15:00Z",
      "content": "Langkah strategis transisi energi dipercepat dengan melibatkan berbagai investor hijau internasional."
    },
    {
      "source": {
        "id": null,
        "name": "Tempo"
      },
      "author": "Siti Rahma",
      "title": "Inovasi Pembelajaran Digital Masuk Kurikulum Sekolah Menengah",
      "description": null,
      "url": "https://example.com/inovasi-pembelajaran-digital",
      "urlToImage": "https://picsum.photos/seed/belajar/600/400",
      "publishedAt": "2026-10-12T14:00:00Z",
      "content": "Kurikulum berbasis komputasi modern mulai diuji coba pada ratusan sekolah percontohan di berbagai daerah."
    },
    {
      "source": {
        "id": "detik",
        "name": "Detikcom"
      },
      "author": "Rian Pratama",
      "title": "Tim Bulu Tangkis Indonesia Lolos ke Babak Final Turnamen Terbuka",
      "description": "Ganda putra andalan berhasil menundukkan lawan unggulan pertama lewat pertarungan tiga gim yang menegangkan.",
      "url": "https://example.com/tim-bulu-tangkis-final",
      "urlToImage": null,
      "publishedAt": "2026-10-12T16:45:00Z",
      "content": "Pertandingan semifinal berlangsung ketat selama lebih dari 70 menit sebelum kemenangan berhasil dikunci."
    },
    {
      "source": null,
      "author": null,
      "title": "Pertumbuhan Ekonomi Sektor Pariwisata Tunjukkan Tren Positif Akhir Tahun",
      "description": "Jumlah kunjungan wisatawan domestik dan mancanegara melampaui target awal kuartal ini.",
      "url": null,
      "urlToImage": null,
      "publishedAt": "2026-10-11T11:20:00Z",
      "content": null
    }
  ]
}
''';
}
