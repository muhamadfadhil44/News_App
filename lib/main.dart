import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:news_app/providers/news_provider.dart';
import 'package:news_app/screens/home_screen.dart';
import 'package:news_app/services/mock_news_service.dart';
import 'package:news_app/services/news_service.dart';
import 'package:news_app/theme/app_theme.dart';

void main() {
  runApp(const NewsApp());
}

/// Widget utama News App dengan penyedia state [NewsProvider] dan tema terpusat.
class NewsApp extends StatelessWidget {
  /// Parameter opsional untuk mempermudah injeksi service pada unit/widget test
  final NewsService? newsService;

  const NewsApp({
    super.key,
    this.newsService,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      // Menginisialisasi NewsProvider menggunakan implementasi NewsService
      // dan langsung memuat data artikel awal secara asinkron.
      create: (_) => NewsProvider(
        newsService: newsService ?? MockNewsService(),
      )..loadArticles(),
      child: MaterialApp(
        title: 'News App',
        theme: AppTheme.lightTheme,
        debugShowCheckedModeBanner: false,
        home: const HomeScreen(),
      ),
    );
  }
}
