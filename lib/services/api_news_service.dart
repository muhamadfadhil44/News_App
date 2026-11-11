import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:news_app/models/article.dart';
import 'package:news_app/services/news_service.dart';
import 'news_exception.dart'; // Jalur impor lokal yang benar untuk berkas di folder yang sama

class ApiNewsService implements NewsService {
  static const _apiKey = String.fromEnvironment('NEWS_API_KEY');

  @override
  Future<List<Article>> fetchArticles({String? query, String? category}) async {
    if (_apiKey.isEmpty) {
      throw NewsException(
        'API key belum diisi. Jalankan dengan --dart-define-from-file=env.json',
      );
    }

    // Logika Penerjemah Kategori Bahasa Indonesia -> Inggris
    String? apiCategory;
    if (category != null) {
      if (category == 'Teknologi') {
        apiCategory = 'technology';
      } else if (category == 'Bisnis') {
        apiCategory = 'business';
      } else if (category == 'Olahraga') {
        apiCategory = 'sports';
      } else if (category == 'Pendidikan') {
        apiCategory = 'science';
      } else if (category == 'Semua') {
        apiCategory = null;
      } else {
        apiCategory = category.toLowerCase();
      }
    }

    final uri = Uri.https('newsapi.org', '/v2/top-headlines', {
      'country': 'us',
      'pageSize': '20',
      if (apiCategory != null) 'category': apiCategory,
      if (query != null && query.isNotEmpty) 'q': query,
    });

    final response = await http
        .get(uri, headers: {'X-Api-Key': _apiKey})
        .timeout(const Duration(seconds: 10));

    if (response.statusCode != 200) {
      throw NewsException(_pesanError(response.statusCode));
    }

    final data = jsonDecode(response.body) as Map<String, dynamic>;
    final items = data['articles'] as List<dynamic>? ?? [];

    return items
        .map((item) => Article.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  String _pesanError(int statusCode) {
    switch (statusCode) {
      case 400:
        return 'Permintaan tidak valid. Periksa parameter yang dikirim.';
      case 401:
        return 'API key salah atau tidak terkirim.';
      case 429:
        return 'Terlalu banyak permintaan atau kuota harian habis. Coba lagi nanti.';
      default:
        return 'Server bermasalah (kode $statusCode). Coba lagi nanti.';
    }
  }
}
