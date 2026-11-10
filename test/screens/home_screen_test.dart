import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:news_app/models/article.dart';
import 'package:news_app/providers/bookmark_provider.dart';
import 'package:news_app/providers/news_provider.dart';
import 'package:news_app/screens/home_screen.dart';
import 'package:news_app/services/news_service.dart';
import 'package:news_app/theme/app_theme.dart';
import 'package:news_app/widgets/article_card.dart';
import 'package:news_app/widgets/state_views.dart';

class MockTestService implements NewsService {
  final Future<List<Article>> Function() onFetch;
  MockTestService(this.onFetch);

  @override
  Future<List<Article>> fetchArticles({String? category, String? query}) =>
      onFetch();
}

Widget createHomeScreenWithService(NewsService service, {BookmarkProvider? bookmarkProvider}) {
  return MultiProvider(
    providers: [
      ChangeNotifierProvider(
        create: (_) => NewsProvider(newsService: service)..loadArticles(),
      ),
      ChangeNotifierProvider(
        create: (_) => bookmarkProvider ?? BookmarkProvider(),
      ),
    ],
    child: MaterialApp(
      theme: AppTheme.lightTheme,
      home: const HomeScreen(),
    ),
  );
}

void main() {
  group('HomeScreen Widget Tests', () {
    testWidgets('Menampilkan LoadingView saat proses pengambilan data',
        (tester) async {
      final service = MockTestService(() async {
        await Future.delayed(const Duration(seconds: 1));
        return [];
      });

      await tester.pumpWidget(createHomeScreenWithService(service));

      expect(find.byType(LoadingView), findsOneWidget);
      expect(find.text('Memuat berita terbaru...'), findsOneWidget);

      await tester.pumpAndSettle();
    });

    testWidgets('Menampilkan daftar ArticleCard saat status sukses',
        (tester) async {
      final sampleArticles = [
        const Article(
          title: 'Judul Berita Pertama',
          sourceName: 'Kompas',
          publishedAt: '2026-10-13T10:00:00Z',
        ),
        const Article(
          title: 'Judul Berita Kedua',
          sourceName: 'Detik',
        ),
      ];

      final service = MockTestService(() async => sampleArticles);

      await tester.pumpWidget(createHomeScreenWithService(service));
      await tester.pumpAndSettle();

      expect(find.byType(ArticleCard), findsNWidgets(2));
      expect(find.text('Judul Berita Pertama'), findsOneWidget);
      expect(find.text('Judul Berita Kedua'), findsOneWidget);
      expect(find.text('Kompas'), findsOneWidget);
      expect(find.text('Detik'), findsOneWidget);
    });

    testWidgets('Mengetuk ArticleCard berpindah ke DetailScreen',
        (tester) async {
      final sampleArticles = [
        const Article(
          title: 'Judul Berita Navigasi',
          sourceName: 'Antara',
          description: 'Rincian deskripsi untuk diuji.',
        ),
      ];

      final service = MockTestService(() async => sampleArticles);

      await tester.pumpWidget(createHomeScreenWithService(service));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Judul Berita Navigasi'));
      await tester.pumpAndSettle();

      expect(find.text('Detail Berita'), findsOneWidget);
      expect(find.text('Judul Berita Navigasi'), findsOneWidget);
      expect(find.text('Baca Selengkapnya'), findsOneWidget);
    });

    testWidgets('Menampilkan ErrorView dengan tombol Coba Lagi saat terjadi error',
        (tester) async {
      int fetchCount = 0;
      final service = MockTestService(() async {
        fetchCount++;
        if (fetchCount == 1) {
          throw Exception('Koneksi internet terputus');
        }
        return [
          const Article(title: 'Berita Sukses Setelah Coba Lagi'),
        ];
      });

      await tester.pumpWidget(createHomeScreenWithService(service));
      await tester.pumpAndSettle();

      expect(find.byType(ErrorView), findsOneWidget);
      expect(find.text('Terjadi Kesalahan'), findsOneWidget);
      expect(find.text('Koneksi internet terputus'), findsOneWidget);

      // Tekan tombol Coba Lagi
      await tester.tap(find.text('Coba Lagi'));
      await tester.pumpAndSettle();

      // Memastikan berita muncul setelah dicoba lagi
      expect(find.byType(ArticleCard), findsOneWidget);
      expect(find.text('Berita Sukses Setelah Coba Lagi'), findsOneWidget);
    });

    testWidgets('Menampilkan EmptyView saat data kosong', (tester) async {
      final service = MockTestService(() async => []);

      await tester.pumpWidget(createHomeScreenWithService(service));
      await tester.pumpAndSettle();

      expect(find.byType(EmptyView), findsOneWidget);
      expect(find.text('Belum Ada Berita'), findsOneWidget);
    });

    testWidgets('Kolom pencarian dan filter chip kategori dapat berinteraksi',
        (tester) async {
      final service = MockTestService(() async {
        return [
          const Article(
            title: 'Berita Hasil Cari',
            sourceName: 'Kompas',
          ),
        ];
      });

      await tester.pumpWidget(createHomeScreenWithService(service));
      await tester.pumpAndSettle();

      // Memastikan kolom cari dan chip kategori tampil
      expect(find.byType(TextField), findsOneWidget);
      expect(find.text('Semua'), findsOneWidget);
      expect(find.text('Teknologi'), findsOneWidget);
      expect(find.text('Bisnis'), findsOneWidget);

      // Ketuk chip kategori Teknologi
      await tester.tap(find.text('Teknologi'));
      await tester.pumpAndSettle();

      // Ketik teks pencarian di TextField
      await tester.enterText(find.byType(TextField), 'robotika');
      await tester.testTextInput.receiveAction(TextInputAction.search);
      await tester.pumpAndSettle();

      expect(find.text('robotika'), findsOneWidget);
    });
  });
}
