import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:news_app/providers/bookmark_provider.dart';
import 'package:news_app/screens/detail_screen.dart';
import 'package:news_app/theme/app_theme.dart';
import 'package:news_app/widgets/article_card.dart';
import 'package:news_app/widgets/state_views.dart';

/// Layar Favorit untuk menampilkan artikel-artikel yang telah ditandai/dibookmark.
/// Terhubung secara reaktif dengan [BookmarkProvider].
class BookmarkScreen extends StatelessWidget {
  const BookmarkScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Artikel Favorit'),
      ),
      body: Consumer<BookmarkProvider>(
        builder: (context, bookmarkProvider, child) {
          final favorites = bookmarkProvider.bookmarkedArticles;

          // Menampilkan tampilan kosong jika belum ada artikel yang dibookmark
          if (favorites.isEmpty) {
            return const EmptyView(
              title: 'Belum Ada Favorit',
              message:
                  'Anda belum menandai artikel sebagai favorit.\nTandai berita menarik di Beranda atau Detail untuk menyimpannya di sini.',
            );
          }

          // Menampilkan daftar artikel favorit menggunakan komponen ArticleCard
          return ListView.separated(
            padding: const EdgeInsets.all(AppTheme.spacingM),
            itemCount: favorites.length,
            separatorBuilder: (context, index) =>
                const SizedBox(height: AppTheme.spacingM),
            itemBuilder: (context, index) {
              final article = favorites[index];
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
                trailingAction: IconButton(
                  icon: const Icon(
                    Icons.bookmark_rounded,
                    color: AppTheme.primary,
                  ),
                  tooltip: 'Hapus dari favorit',
                  onPressed: () {
                    bookmarkProvider.removeBookmark(article);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Artikel dihapus dari favorit.'),
                        duration: Duration(seconds: 1),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
