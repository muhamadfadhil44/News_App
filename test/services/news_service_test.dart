import 'package:flutter_test/flutter_test.dart';
import 'package:news_app/models/article.dart';
import 'package:news_app/services/mock_news_service.dart';
import 'package:news_app/services/news_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('MockNewsService Tests', () {
    test('MockNewsService adalah turunan dari kelas abstrak NewsService', () {
      final NewsService service = MockNewsService(delay: Duration.zero);
      expect(service, isA<NewsService>());
    });

    test('State Sukses: Mengembalikan daftar artikel dari mock JSON', () async {
      final service = MockNewsService(
        simulatedState: MockState.success,
        delay: Duration.zero,
      );

      final articles = await service.fetchArticles();

      expect(articles, isNotEmpty);
      expect(articles.length, 5);
      expect(articles.first, isA<Article>());
      expect(articles.first.title, isNotEmpty);
    });

    test('State Error: Melempar Exception saat dipanggil', () async {
      final service = MockNewsService(
        simulatedState: MockState.error,
        delay: Duration.zero,
      );

      expect(
        () async => await service.fetchArticles(),
        throwsA(isA<Exception>()),
      );
    });

    test('State Kosong: Mengembalikan list artikel kosong', () async {
      final service = MockNewsService(
        simulatedState: MockState.empty,
        delay: Duration.zero,
      );

      final articles = await service.fetchArticles();

      expect(articles, isEmpty);
    });

    test('Pencarian (query): Menyaring artikel berdasarkan kata kunci', () async {
      final service = MockNewsService(
        simulatedState: MockState.success,
        delay: Duration.zero,
      );

      final result = await service.fetchArticles(query: 'satelit');

      expect(result.length, 1);
      expect(result.first.title.toLowerCase(), contains('satelit'));
    });
  });
}
