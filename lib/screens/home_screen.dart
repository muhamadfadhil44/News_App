import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:news_app/providers/news_provider.dart';
import 'package:news_app/screens/detail_screen.dart';
import 'package:news_app/theme/app_theme.dart';
import 'package:news_app/widgets/article_card.dart';
import 'package:news_app/widgets/state_views.dart';

/// Layar Beranda utama aplikasi berita.
/// Terhubung dengan [NewsProvider] untuk menangani 4 status jaringan:
/// - Loading
/// - Sukses
/// - Error
/// - Kosong
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Berita Terkini'),
      ),
      body: Consumer<NewsProvider>(
        builder: (context, provider, child) {
          // 1. Tampilan saat data sedang dimuat (Loading State)
          if (provider.isLoading) {
            return const LoadingView(
              message: 'Memuat berita terbaru...',
            );
          }

          // 2. Tampilan saat terjadi kegagalan (Error State)
          if (provider.isError) {
            return ErrorView(
              message: provider.errorMessage,
              onRetry: () => provider.loadArticles(),
            );
          }

          // 3. Tampilan saat tidak ada artikel yang ditemukan (Empty State)
          if (provider.isEmpty) {
            return RefreshIndicator(
              onRefresh: () => provider.refreshArticles(),
              child: ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.6,
                    child: EmptyView(
                      onRetry: () => provider.loadArticles(),
                    ),
                  ),
                ],
              ),
            );
          }

          // 4. Tampilan saat data berhasil dimuat (Success State)
          return RefreshIndicator(
            onRefresh: () => provider.refreshArticles(),
            child: ListView.separated(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(AppTheme.spacingM),
              itemCount: provider.articles.length,
              separatorBuilder: (context, index) =>
                  const SizedBox(height: AppTheme.spacingM),
              itemBuilder: (context, index) {
                final article = provider.articles[index];
                return ArticleCard(
                  article: article,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DetailScreen(article: article),
                      ),
                    );
                  },
                );
              },
            ),
          );
        },
      ),
    );
  }
}
