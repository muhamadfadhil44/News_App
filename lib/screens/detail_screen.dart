import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:news_app/models/article.dart';
import 'package:news_app/providers/bookmark_provider.dart';
import 'package:news_app/theme/app_theme.dart';

/// Layar Detail Berita untuk menampilkan rincian informasi artikel.
/// Sesuai PRD Fitur 3:
/// - Gambar artikel dengan placeholder jika kosong atau gagal dimuat.
/// - Judul berita.
/// - Penulis dan sumber berita.
/// - Tanggal publikasi terformat.
/// - Deskripsi dan konten artikel.
/// - Tombol "Baca Selengkapnya" (aksi membuka tautan eksternal dipasang pada tahap integrasi).
class DetailScreen extends StatelessWidget {
  final Article article;

  const DetailScreen({
    super.key,
    required this.article,
  });

  /// Memformat tanggal terbit sederhana (DD/MM/YYYY) tanpa package eksternal.
  String _formatPublishedDate(String? rawDate) {
    if (rawDate == null || rawDate.isEmpty) {
      return '-';
    }
    final parsed = DateTime.tryParse(rawDate);
    if (parsed != null) {
      final day = parsed.day.toString().padLeft(2, '0');
      final month = parsed.month.toString().padLeft(2, '0');
      final year = parsed.year.toString();
      return '$day/$month/$year';
    }
    return rawDate;
  }

  /// Placeholder saat gambar artikel tidak tersedia atau gagal dimuat.
  Widget _buildImagePlaceholder() {
    return Container(
      height: 240,
      width: double.infinity,
      color: AppTheme.border,
      child: const Center(
        child: Icon(
          Icons.image_not_supported_outlined,
          color: AppTheme.textSecondary,
          size: AppTheme.spacingXxl,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final hasImage =
        article.urlToImage != null && article.urlToImage!.trim().isNotEmpty;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Berita'),
        actions: [
          Consumer<BookmarkProvider>(
            builder: (context, bookmarkProvider, child) {
              final isFav = bookmarkProvider.isBookmarked(article);
              return IconButton(
                icon: Icon(
                  isFav ? Icons.bookmark_rounded : Icons.bookmark_outline_rounded,
                  color: isFav ? AppTheme.primary : AppTheme.textPrimary,
                ),
                tooltip: isFav ? 'Hapus dari favorit' : 'Simpan ke favorit',
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
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Gambar Berita dengan placeholder
            if (hasImage)
              Image.network(
                article.urlToImage!,
                height: 240,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                    _buildImagePlaceholder(),
              )
            else
              _buildImagePlaceholder(),

            // 2. Konten Rincian Berita
            Padding(
              padding: const EdgeInsets.all(AppTheme.spacingM),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Baris Sumber Berita dan Tanggal
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppTheme.spacingS,
                          vertical: AppTheme.spacingXs,
                        ),
                        decoration: BoxDecoration(
                          color: AppTheme.primaryContainer,
                          borderRadius:
                              BorderRadius.circular(AppTheme.radiusS),
                        ),
                        child: Text(
                          article.sourceName ?? 'Sumber Umum',
                          style: const TextStyle(
                            fontSize: AppTheme.fontSizeBody,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.primary,
                          ),
                        ),
                      ),
                      const Spacer(),
                      const Icon(
                        Icons.access_time_rounded,
                        size: AppTheme.spacingM,
                        color: AppTheme.textSecondary,
                      ),
                      const SizedBox(width: AppTheme.spacingXs),
                      Text(
                        _formatPublishedDate(article.publishedAt),
                        style: AppTheme.bodyStyle,
                      ),
                    ],
                  ),

                  const SizedBox(height: AppTheme.spacingM),

                  // Judul Berita
                  Text(
                    article.title,
                    style: AppTheme.titleStyle,
                  ),

                  const SizedBox(height: AppTheme.spacingS),

                  // Penulis Berita
                  Row(
                    children: [
                      const Icon(
                        Icons.person_outline_rounded,
                        size: AppTheme.spacingM,
                        color: AppTheme.textSecondary,
                      ),
                      const SizedBox(width: AppTheme.spacingXs),
                      Expanded(
                        child: Text(
                          article.author != null &&
                                  article.author!.trim().isNotEmpty
                              ? 'Oleh: ${article.author}'
                              : 'Penulis: Tidak disebutkan',
                          style: AppTheme.bodyStyle,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: AppTheme.spacingM),
                  const Divider(),
                  const SizedBox(height: AppTheme.spacingM),

                  // Deskripsi Berita
                  if (article.description != null &&
                      article.description!.trim().isNotEmpty) ...[
                    Text(
                      article.description!,
                      style: AppTheme.bodyStyle.copyWith(
                        color: AppTheme.textPrimary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: AppTheme.spacingM),
                  ],

                  // Konten Berita
                  if (article.content != null &&
                      article.content!.trim().isNotEmpty) ...[
                    Text(
                      article.content!,
                      style: AppTheme.bodyStyle,
                    ),
                    const SizedBox(height: AppTheme.spacingL),
                  ] else ...[
                    if (article.description == null ||
                        article.description!.trim().isEmpty) ...[
                      const Text(
                        'Tidak ada rincian konten tambahan untuk berita ini.',
                        style: AppTheme.bodyStyle,
                      ),
                      const SizedBox(height: AppTheme.spacingL),
                    ],
                  ],

                  // Tombol Baca Selengkapnya
                  // Sesuai PRD: Membuka link browser sesungguhnya disiapkan pada tahap integrasi
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Aksi membuka tautan web akan dipasang pada tahap integrasi API.',
                            ),
                            duration: Duration(seconds: 2),
                          ),
                        );
                      },
                      icon: const Icon(Icons.open_in_browser_rounded),
                      label: const Text('Baca Selengkapnya'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
