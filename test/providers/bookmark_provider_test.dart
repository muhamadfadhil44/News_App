import 'package:flutter_test/flutter_test.dart';
import 'package:news_app/models/article.dart';
import 'package:news_app/providers/bookmark_provider.dart';

void main() {
  group('BookmarkProvider Tests', () {
    const article1 = Article(
      title: 'Judul Artikel 1',
      sourceName: 'Kompas',
      url: 'https://example.com/1',
    );

    const article2 = Article(
      title: 'Judul Artikel 2',
      sourceName: 'Tempo',
      url: 'https://example.com/2',
    );

    test('Kondisi awal bookmark kosong', () {
      final provider = BookmarkProvider();
      expect(provider.bookmarkedArticles, isEmpty);
      expect(provider.isBookmarked(article1), isFalse);
    });

    test('addBookmark menambahkan artikel ke favorit', () {
      final provider = BookmarkProvider();
      provider.addBookmark(article1);

      expect(provider.bookmarkedArticles.length, 1);
      expect(provider.isBookmarked(article1), isTrue);
      expect(provider.isBookmarked(article2), isFalse);
    });

    test('addBookmark tidak menambahkan artikel duplikat', () {
      final provider = BookmarkProvider();
      provider.addBookmark(article1);
      provider.addBookmark(article1);

      expect(provider.bookmarkedArticles.length, 1);
    });

    test('removeBookmark menghapus artikel dari favorit', () {
      final provider = BookmarkProvider();
      provider.addBookmark(article1);
      expect(provider.isBookmarked(article1), isTrue);

      provider.removeBookmark(article1);
      expect(provider.bookmarkedArticles, isEmpty);
      expect(provider.isBookmarked(article1), isFalse);
    });

    test('toggleBookmark bergantian menambah dan menghapus artikel', () {
      final provider = BookmarkProvider();

      // Pertama kali: menambah
      final added = provider.toggleBookmark(article1);
      expect(added, isTrue);
      expect(provider.isBookmarked(article1), isTrue);
      expect(provider.bookmarkedArticles.length, 1);

      // Kedua kali: menghapus
      final removed = provider.toggleBookmark(article1);
      expect(removed, isFalse);
      expect(provider.isBookmarked(article1), isFalse);
      expect(provider.bookmarkedArticles, isEmpty);
    });
  });
}
