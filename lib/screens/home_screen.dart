import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:news_app/providers/bookmark_provider.dart';
import 'package:news_app/providers/news_provider.dart';
import 'package:news_app/screens/bookmark_screen.dart';
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
        actions: [
          IconButton(
            icon: const Icon(Icons.bookmark_rounded),
            tooltip: 'Artikel Favorit',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const BookmarkScreen(),
                ),
              );
            },
          ),
        ],
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
                  trailingAction: Consumer<BookmarkProvider>(
                    builder: (context, bookmarkProvider, child) {
                      final isFav = bookmarkProvider.isBookmarked(article);
                      return IconButton(
                        icon: Icon(
                          isFav
                              ? Icons.bookmark_rounded
                              : Icons.bookmark_outline_rounded,
                          color: isFav
                              ? AppTheme.primary
                              : AppTheme.textSecondary,
                        ),
                        tooltip: isFav
                            ? 'Hapus dari favorit'
                            : 'Simpan ke favorit',
                        onPressed: () {
                          final added = bookmarkProvider.toggleBookmark(article);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                added
                                    ? 'Artikel ditambahkan ke favorit.'
                                    : 'Artikel dihapus dari favorit.',
                              ),
                              duration: const Duration(seconds: 1),
                            ),
                          );
                        },
                      );
                    },
                  ),
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
