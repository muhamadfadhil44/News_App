import 'package:flutter_test/flutter_test.dart';
import 'package:news_app/main.dart';

void main() {
  testWidgets('NewsApp smoke test', (WidgetTester tester) async {
    // Membangun aplikasi dan memicu frame.
    await tester.pumpWidget(const NewsApp());

    // Memverifikasi teks judul News App muncul di layar.
    expect(find.text('News App'), findsOneWidget);
  });
}
