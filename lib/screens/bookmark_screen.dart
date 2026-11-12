import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:news_app/providers/bookmark_provider.dart';
import 'package:news_app/screens/detail_screen.dart';
import 'package:news_app/theme/app_theme.dart';
import 'package:news_app/widgets/article_card.dart';
import 'package:news_app/widgets/state_views.dart';

/// Layar Favorit ("Berita Tersimpan - Nusantara Post" sesuai Stitch Design)
/// untuk menampilkan daftar artikel yang telah ditandai/dibookmark.
/// Terhubung secara reaktif dengan [BookmarkProvider].
class BookmarkScreen extends StatelessWidget {
  const BookmarkScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: AppTheme.spacingXs,
        title: Row(
          children: [
            Container(
              width: AppTheme.spacingXl,
              height: AppTheme.spacingXl,
              decoration: BoxDecoration(
                color: AppTheme.primaryContainer,
                borderRadius: BorderRadius.circular(AppTheme.radiusS),
              ),
              child: const Center(
                child: Icon(
                  Icons.newspaper_rounded,
                  color: AppTheme.onPrimary,
                  size: AppTheme.iconSizeM,
                ),
              ),
            ),
            const SizedBox(width: AppTheme.spacingS),
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Nusantara Post',
                  style: AppTheme.brandTitleStyle,
                ),
                Text(
                  'Artikel Favorit',
                  style: AppTheme.subHeaderLabelStyle,
                ),
              ],
            ),
          ],
        ),
      ),
      // Consumer mendengarkan perubahan daftar bookmark dari BookmarkProvider
      body: Consumer<BookmarkProvider>(
        builder: (context, bookmarkProvider, child) {
          final favorites = bookmarkProvider.bookmarkedArticles;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Editorial Berita Tersimpan (Sesuai Desain Stitch)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(
                  AppTheme.spacingM,
                  AppTheme.spacingS,
                  AppTheme.spacingM,
                  AppTheme.spacingM,
                ),
                decoration: const BoxDecoration(
                  color: AppTheme.background,
                  border: Border(
                    bottom: BorderSide(color: AppTheme.border),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(
                          Icons.bookmarks_outlined,
                          size: AppTheme.iconSizeS,
                          color: AppTheme.secondary,
                        ),
                        SizedBox(width: AppTheme.spacingXs),
                        Text(
                          'KOLEKSI BACAAN PILIHAN',
                          style: AppTheme.subHeaderLabelStyle,
                        ),
                      ],
                    ),
                    const SizedBox(height: AppTheme.spacingXs),
                    const Text(
                      'Berita Tersimpan',
                      style: AppTheme.headlineLargeStyle,
                    ),
                    const SizedBox(height: AppTheme.spacingXs),
                    Text(
                      'Koleksi ${favorites.length} artikel yang Anda simpan untuk dibaca kembali selama sesi aplikasi.',
                      style: AppTheme.bodyStyle,
                    ),
                    const SizedBox(height: AppTheme.spacingSm),
                    // Chip Indikator Jumlah Simpanan
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppTheme.spacingSm,
                        vertical: AppTheme.spacingXs,
                      ),
                      decoration: BoxDecoration(
                        color: AppTheme.primary,
                        borderRadius: BorderRadius.circular(AppTheme.radiusS),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'SEMUA',
                            style: AppTheme.subHeaderLabelStyle.copyWith(
                              color: AppTheme.onPrimary,
                            ),
                          ),
                          const SizedBox(width: AppTheme.spacingS),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppTheme.spacingXs +
                                  AppTheme.spacingXxs,
                              vertical: AppTheme.spacingXxs,
                            ),
                            decoration: BoxDecoration(
                              color: AppTheme.surface,
                              borderRadius:
                                  BorderRadius.circular(AppTheme.radiusFull),
                            ),
                            child: Text(
                              '${favorites.length}',
                              style: AppTheme.subHeaderLabelStyle.copyWith(
                                color: AppTheme.primary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Daftar Artikel Tersimpan atau Tampilan Kosong
              Expanded(
                child: favorites.isEmpty
                    ? const EmptyView(
                        title: 'Belum Ada Favorit',
                        message:
                            'Anda belum menandai artikel sebagai favorit.\nTelusuri berita terbaru di Beranda dan tekan ikon bookmark untuk menyimpannya.',
                        icon: Icons.bookmark_border_rounded,
                      )
                    : ListView.separated(
                        padding: const EdgeInsets.all(AppTheme.spacingM),
                        itemCount: favorites.length,
                        separatorBuilder: (context, index) =>
                            const SizedBox(height: AppTheme.spacingSm),
                        itemBuilder: (context, index) {
                          final article = favorites[index];
                          return ArticleCard(
                            article: article,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      DetailScreen(article: article),
                                ),
                              );
                            },
                            trailingAction: IconButton(
                              visualDensity: VisualDensity.compact,
                              icon: const Icon(
                                Icons.bookmark_rounded,
                                color: AppTheme.secondary,
                                size: AppTheme.iconSizeM,
                              ),
                              tooltip: 'Hapus dari favorit',
                              onPressed: () {
                                bookmarkProvider.removeBookmark(article);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content:
                                        Text('Artikel dihapus dari favorit.'),
                                    duration: Duration(seconds: 1),
                                  ),
                                );
                              },
                            ),
                          );
                        },
                      ),
              ),
            ],
          );
        },
      ),
    );
  }
}
