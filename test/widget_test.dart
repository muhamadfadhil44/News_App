import 'package:flutter_test/flutter_test.dart';
import 'package:news_app/main.dart';
import 'package:news_app/services/mock_news_service.dart';

void main() {
  testWidgets('NewsApp smoke test memuat Beranda', (WidgetTester tester) async {
    // Membangun aplikasi dengan service delay nol agar pengujian berjalan cepat
    await tester.pumpWidget(NewsApp(
      newsService: MockNewsService(delay: Duration.zero),
    ));

    // Memverifikasi judul aplikasi di AppBar Beranda muncul
    expect(find.text('Berita Terkini'), findsOneWidget);

    // Menunggu hingga semua frame dan proses asinkron selesai
    await tester.pumpAndSettle();
  });
}
