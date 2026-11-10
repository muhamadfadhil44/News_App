import 'dart:convert';
import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:news_app/models/article.dart';

void main() {
  group('Article Model Tests', () {
    test('Berhasil melakukan parsing dari JSON dengan field lengkap', () {
      final jsonMap = {
        'source': {'id': 'techcrunch', 'name': 'TechCrunch'},
        'author': 'Jane Doe',
        'title': 'Flutter 3 Dirilis dengan Fitur Baru',
        'description': 'Pembaruan terkini seputar ekosistem Flutter.',
        'url': 'https://techcrunch.com/flutter-3',
        'urlToImage': 'https://techcrunch.com/image.png',
        'publishedAt': '2026-10-13T10:00:00Z',
        'content': 'Konten lengkap mengenai rilis Flutter 3...',
      };

      // Memanggil method factory fromJson
      final article = Article.fromJson(jsonMap);

      expect(article.sourceName, 'TechCrunch');
      expect(article.author, 'Jane Doe');
      expect(article.title, 'Flutter 3 Dirilis dengan Fitur Baru');
      expect(article.description, 'Pembaruan terkini seputar ekosistem Flutter.');
      expect(article.url, 'https://techcrunch.com/flutter-3');
      expect(article.urlToImage, 'https://techcrunch.com/image.png');
      expect(article.publishedAt, '2026-10-13T10:00:00Z');
      expect(article.content, 'Konten lengkap mengenai rilis Flutter 3...');
    });

    test('Berhasil menangani nilai null pada field opsional', () {
      final jsonWithNulls = {
        'source': null,
        'author': null,
        'title': 'Judul Penting',
        'description': null,
        'url': null,
        'urlToImage': null,
        'publishedAt': null,
        'content': null,
      };

      final article = Article.fromJson(jsonWithNulls);

      expect(article.sourceName, isNull);
      expect(article.author, isNull);
      expect(article.title, 'Judul Penting');
      expect(article.description, isNull);
      expect(article.url, isNull);
      expect(article.urlToImage, isNull);
      expect(article.publishedAt, isNull);
      expect(article.content, isNull);
    });

    test('Memberikan fallback title jika field title bernilai null atau kosong', () {
      final jsonEmptyTitle = {
        'source': {'name': 'Kompas'},
        'title': '',
      };

      final article = Article.fromJson(jsonEmptyTitle);
      expect(article.title, 'Tanpa Judul');
    });

    test('Berhasil mem-parsing seluruh data dari assets/mock/articles.json', () {
      final file = File('assets/mock/articles.json');
      expect(file.existsSync(), isTrue, reason: 'File mock JSON harus ada');

      final jsonString = file.readAsStringSync();
      final Map<String, dynamic> decodedData = jsonDecode(jsonString);

      expect(decodedData['status'], 'ok');
      expect(decodedData['articles'], isA<List>());

      final List<dynamic> rawArticles = decodedData['articles'];
      final List<Article> articles = rawArticles
          .map((item) => Article.fromJson(item as Map<String, dynamic>))
          .toList();

      expect(articles.length, 5);
      expect(articles[0].sourceName, 'Antara News');
      expect(articles[0].author, 'Budi Santoso');
      expect(articles[1].author, isNull);
      expect(articles[2].description, isNull);
      expect(articles[3].urlToImage, isNull);
      expect(articles[4].sourceName, isNull);
    });
  });
}
