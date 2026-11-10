import 'package:flutter_test/flutter_test.dart';
import 'package:news_app/models/article.dart';
import 'package:news_app/providers/news_provider.dart';
import 'package:news_app/services/news_service.dart';

class FakeSuccessNewsService implements NewsService {
  @override
  Future<List<Article>> fetchArticles({String? category, String? query}) async {
    return [
      const Article(
        title: 'Berita Uji Coba',
        sourceName: 'Sumber Uji',
        description: 'Deskripsi uji coba',
      ),
    ];
  }
}

class FakeEmptyNewsService implements NewsService {
  @override
  Future<List<Article>> fetchArticles({String? category, String? query}) async {
    return [];
  }
}

class FakeErrorNewsService implements NewsService {
  @override
  Future<List<Article>> fetchArticles({String? category, String? query}) async {
    throw Exception('Koneksi internet bermasalah');
  }
}

void main() {
  group('NewsProvider Tests', () {
    test('Kondisi awal provider adalah loading', () {
      final provider = NewsProvider(newsService: FakeSuccessNewsService());
      expect(provider.status, NewsStatus.loading);
      expect(provider.isLoading, isTrue);
      expect(provider.articles, isEmpty);
    });

    test('loadArticles sukses mengubah status ke success dan mengisi artikel', () async {
      final provider = NewsProvider(newsService: FakeSuccessNewsService());
      await provider.loadArticles();

      expect(provider.status, NewsStatus.success);
      expect(provider.isSuccess, isTrue);
      expect(provider.articles.length, 1);
      expect(provider.articles.first.title, 'Berita Uji Coba');
    });

    test('loadArticles kosong mengubah status ke empty', () async {
      final provider = NewsProvider(newsService: FakeEmptyNewsService());
      await provider.loadArticles();

      expect(provider.status, NewsStatus.empty);
      expect(provider.isEmpty, isTrue);
      expect(provider.articles, isEmpty);
    });

    test('loadArticles error mengubah status ke error dan menyimpan pesan', () async {
      final provider = NewsProvider(newsService: FakeErrorNewsService());
      await provider.loadArticles();

      expect(provider.status, NewsStatus.error);
      expect(provider.isError, isTrue);
      expect(provider.errorMessage, 'Koneksi internet bermasalah');
    });
  });
}
