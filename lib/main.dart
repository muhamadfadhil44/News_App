import 'package:flutter/material.dart';
import 'package:news_app/theme/app_theme.dart';

void main() {
  runApp(const NewsApp());
}

/// Widget utama News App dengan penerapan tema terpusat.
class NewsApp extends StatelessWidget {
  const NewsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'News App',
      theme: AppTheme.lightTheme,
      debugShowCheckedModeBanner: false,
      home: const Scaffold(
        body: Center(
          child: Text(
            'News App',
            style: AppTheme.titleStyle,
          ),
        ),
      ),
    );
  }
}
