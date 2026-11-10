import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:news_app/models/article.dart';
import 'package:news_app/providers/bookmark_provider.dart';
import 'package:news_app/screens/bookmark_screen.dart';
import 'package:news_app/theme/app_theme.dart';
import 'package:news_app/widgets/article_card.dart';
import 'package:news_app/widgets/state_views.dart';

Widget createBookmarkScreen(BookmarkProvider bookmarkProvider) {
  return ChangeNotifierProvider.value(
    value: bookmarkProvider,
    child: MaterialApp(
      theme: AppTheme.lightTheme,
      home: const BookmarkScreen(),
    ),
  );
}

void main() {
  group('BookmarkScreen Widget Tests', () {
    const sampleArticle = Article(
      title: 'Judul Artikel Favorit',
      sourceName: 'Kompas',
      url: 'https://example.com/fav',
    );

    testWidgets('Menampilkan EmptyView saat belum ada artikel favorit',
        (tester) async {
      final provider = BookmarkProvider();

      await tester.pumpWidget(createBookmarkScreen(provider));
      await tester.pumpAndSettle();

      expect(find.byType(EmptyView), findsOneWidget);
      expect(find.text('Belum Ada Favorit'), findsOneWidget);
    });

    testWidgets('Menampilkan daftar artikel saat ada artikel yang difavoritkan',
        (tester) async {
      final provider = BookmarkProvider();
      provider.addBookmark(sampleArticle);

      await tester.pumpWidget(createBookmarkScreen(provider));
      await tester.pumpAndSettle();

      expect(find.byType(ArticleCard), findsOneWidget);
      expect(find.text('Judul Artikel Favorit'), findsOneWidget);
      expect(find.text('Kompas'), findsOneWidget);
    });

    testWidgets('Menghapus artikel favorit saat ikon bookmark diketuk',
        (tester) async {
      final provider = BookmarkProvider();
      provider.addBookmark(sampleArticle);

      await tester.pumpWidget(createBookmarkScreen(provider));
      await tester.pumpAndSettle();

      expect(find.byType(ArticleCard), findsOneWidget);

      // Ketuk tombol hapus bookmark
      await tester.tap(find.byIcon(Icons.bookmark_rounded));
      await tester.pumpAndSettle();

      expect(find.byType(ArticleCard), findsNothing);
      expect(find.byType(EmptyView), findsOneWidget);
      expect(find.text('Artikel dihapus dari favorit.'), findsOneWidget);
    });
  });
}
