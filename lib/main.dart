import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:news_app/providers/bookmark_provider.dart';
import 'package:news_app/providers/news_provider.dart';
import 'package:news_app/screens/home_screen.dart';
import 'package:news_app/services/mock_news_service.dart';
import 'package:news_app/services/news_service.dart';
import 'package:news_app/theme/app_theme.dart';

void main() {
  runApp(const NewsApp());
}

/// Widget utama News App dengan penyedia state [NewsProvider] dan [BookmarkProvider].
class NewsApp extends StatelessWidget {
  /// Parameter opsional untuk mempermudah injeksi service pada unit/widget test
  final NewsService? newsService;

  const NewsApp({
    super.key,
    this.newsService,
  });

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // 1. Provider untuk data berita dan status koneksi jaringan
        ChangeNotifierProvider(
          create: (_) => NewsProvider(
            newsService: newsService ?? MockNewsService(),
          )..loadArticles(),
        ),
        // 2. Provider untuk pengelolaan bookmark artikel favorit di memori
        ChangeNotifierProvider(
          create: (_) => BookmarkProvider(),
        ),
      ],
      child: MaterialApp(
        title: 'News App',
        theme: AppTheme.lightTheme,
        debugShowCheckedModeBanner: false,
        home: const HomeScreen(),
      ),
    );
  }
}
