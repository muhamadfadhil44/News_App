import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:news_app/models/article.dart';
import 'package:news_app/providers/bookmark_provider.dart';
import 'package:news_app/screens/detail_screen.dart';
import 'package:news_app/theme/app_theme.dart';

void main() {
  Widget createDetailScreen(Article article, {BookmarkProvider? bookmarkProvider}) {
    return ChangeNotifierProvider<BookmarkProvider>(
      create: (_) => bookmarkProvider ?? BookmarkProvider(),
      child: MaterialApp(
        theme: AppTheme.lightTheme,
        home: DetailScreen(article: article),
      ),
    );
  }

  group('DetailScreen Widget Tests', () {
    testWidgets('Menampilkan seluruh rincian artikel lengkap dengan benar',
        (WidgetTester tester) async {
      const fullArticle = Article(
        title: 'Misi Antariksa Sukses Diluncurkan',
        sourceName: 'Kompas',
        author: 'Ahmad Faiz',
        publishedAt: '2026-10-13T10:00:00Z',
        description: 'Deskripsi singkat mengenai peluncuran misi luar angkasa.',
        content: 'Konten komprehensif mengenai roket pembawa satelit.',
        url: 'https://example.com/misi-antariksa',
      );

      await tester.pumpWidget(createDetailScreen(fullArticle));

      expect(find.text('Detail Berita'), findsOneWidget);
      expect(find.text('Misi Antariksa Sukses Diluncurkan'), findsOneWidget);
      expect(find.text('Kompas'), findsOneWidget);
      expect(find.text('Oleh: Ahmad Faiz'), findsOneWidget);
      expect(find.text('Deskripsi singkat mengenai peluncuran misi luar angkasa.'),
          findsOneWidget);
      expect(find.text('Konten komprehensif mengenai roket pembawa satelit.'),
          findsOneWidget);
      expect(find.text('Baca Selengkapnya'), findsOneWidget);
    });

    testWidgets(
        'Menangani artikel dengan nilai null (tanpa penulis, deskripsi, konten, gambar) dengan rapi',
        (WidgetTester tester) async {
      const emptyFieldsArticle = Article(
        title: 'Berita Minimalis Tanpa Detail',
        sourceName: null,
        author: null,
        publishedAt: null,
        description: null,
        content: null,
        urlToImage: null,
      );

      await tester.pumpWidget(createDetailScreen(emptyFieldsArticle));

      expect(find.text('Detail Berita'), findsOneWidget);
      expect(find.text('Berita Minimalis Tanpa Detail'), findsOneWidget);
      expect(find.text('Sumber Umum'), findsOneWidget);
      expect(find.text('Penulis: Tidak disebutkan'), findsOneWidget);
      expect(find.text('-'), findsOneWidget);
      expect(find.text('Tidak ada rincian konten tambahan untuk berita ini.'),
          findsOneWidget);
      expect(find.byIcon(Icons.image_not_supported_outlined), findsOneWidget);
      expect(find.text('Baca Selengkapnya'), findsOneWidget);
    });

    testWidgets('Menekan tombol Baca Selengkapnya menampilkan notifikasi SnackBar',
        (WidgetTester tester) async {
      const article = Article(
        title: 'Judul Berita',
        sourceName: 'Tempo',
      );

      await tester.pumpWidget(createDetailScreen(article));

      await tester.tap(find.text('Baca Selengkapnya'));
      await tester.pump();

      expect(
        find.text(
          'Aksi membuka tautan web akan dipasang pada tahap integrasi API.',
        ),
        findsOneWidget,
      );
    });
  });
}
