import 'package:flutter/material.dart';
import 'package:news_app/models/article.dart';
import 'package:news_app/theme/app_theme.dart';

/// Komponen kartu artikel bergaya editorial "Nusantara Post" (Stitch Design)
/// yang digunakan ulang di layar Beranda dan Berita Tersimpan (Favorit).
///
/// Fitur:
/// - Mendukung tampilan Sorotan Utama ([isFeatured] = true) dan daftar Berita Terkini ([isFeatured] = false).
/// - Menampilkan gambar dengan placeholder jika URL null atau gagal dimuat.
/// - Menampilkan nama sumber, tanggal terbit, dan judul berita.
/// - Menangani nilai null secara aman pada seluruh field artikel.
/// - Seluruh styling warna, tipografi, dan jarak mengacu ke [AppTheme].
class ArticleCard extends StatelessWidget {
  final Article article;
  final VoidCallback? onTap;
  final Widget? trailingAction;
  final bool isFeatured;

  const ArticleCard({
    super.key,
    required this.article,
    this.onTap,
    this.trailingAction,
    this.isFeatured = false,
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

  /// Widget placeholder saat gambar tidak tersedia atau gagal diunduh.
  Widget _buildImagePlaceholder({required double height, double? width}) {
    return Container(
      height: height,
      width: width ?? double.infinity,
      color: AppTheme.placeholder,
      child: const Center(
        child: Icon(
          Icons.image_not_supported_outlined,
          color: AppTheme.textSecondary,
          size: AppTheme.iconSizeL,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isFeatured) {
      return _buildFeaturedCard();
    }
    return _buildCompactEditorialCard();
  }

  /// Tampilan kartu besar "Sorotan Utama" sesuai desain Stitch Beranda.
  Widget _buildFeaturedCard() {
    final hasImage =
        article.urlToImage != null && article.urlToImage!.trim().isNotEmpty;

    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppTheme.radiusM),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Gambar Utama dengan Badge Sumber di Pojok Kiri Atas
            Stack(
              children: [
                if (hasImage)
                  Image.network(
                    article.urlToImage!,
                    height: AppTheme.featuredImageHeight,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) =>
                        _buildImagePlaceholder(
                      height: AppTheme.featuredImageHeight,
                    ),
                  )
                else
                  _buildImagePlaceholder(
                    height: AppTheme.featuredImageHeight,
                  ),
                Positioned(
                  top: AppTheme.spacingSm,
                  left: AppTheme.spacingSm,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppTheme.spacingS,
                      vertical: AppTheme.spacingXs,
                    ),
                    decoration: BoxDecoration(
                      color: AppTheme.surface,
                      borderRadius: BorderRadius.circular(AppTheme.radiusXs),
                    ),
                    child: Text(
                      article.sourceName ?? 'Sumber Umum',
                      style: AppTheme.sourceTagStyle.copyWith(
                        color: AppTheme.primary,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            // Konten Teks Sorotan Utama
            Padding(
              padding: const EdgeInsets.all(AppTheme.spacingSm),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          article.title,
                          style: AppTheme.titleStyle,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (trailingAction != null) ...[
                        const SizedBox(width: AppTheme.spacingS),
                        trailingAction!,
                      ],
                    ],
                  ),
                  if (article.description != null &&
                      article.description!.trim().isNotEmpty) ...[
                    const SizedBox(height: AppTheme.spacingXs),
                    Text(
                      article.description!,
                      style: AppTheme.bodyStyle,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                  const SizedBox(height: AppTheme.spacingXs),
                  const Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _formatPublishedDate(article.publishedAt),
                        style: AppTheme.labelStyle,
                      ),
                      const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.schedule_rounded,
                            size: AppTheme.iconSizeXs,
                            color: AppTheme.textSecondary,
                          ),
                          SizedBox(width: AppTheme.spacingXs),
                          Text(
                            'Baca 4 mnt',
                            style: AppTheme.labelStyle,
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Tampilan kartu horizontal kompak sesuai desain Stitch "Berita Terkini" & "Berita Tersimpan".
  Widget _buildCompactEditorialCard() {
    final hasImage =
        article.urlToImage != null && article.urlToImage!.trim().isNotEmpty;

    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppTheme.radiusM),
        child: Padding(
          padding: const EdgeInsets.all(AppTheme.spacingM),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Kolom Kiri: Sumber, Judul, Waktu Terbit, & Aksi Bookmark
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Label Sumber / Kategori berwarna merah editorial
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppTheme.spacingS,
                        vertical: AppTheme.spacingXxs,
                      ),
                      decoration: BoxDecoration(
                        color: AppTheme.surfaceContainerLow,
                        borderRadius: BorderRadius.circular(AppTheme.radiusXs),
                      ),
                      child: Text(
                        article.sourceName ?? 'Sumber Umum',
                        style: AppTheme.sourceTagStyle,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(height: AppTheme.spacingXs),

                    // Judul Berita
                    Text(
                      article.title,
                      style: AppTheme.cardTitleStyle,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),

                    if (article.description != null &&
                        article.description!.trim().isNotEmpty) ...[
                      const SizedBox(height: AppTheme.spacingXs),
                      Text(
                        article.description!,
                        style: AppTheme.bodyStyle,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],

                    const SizedBox(height: AppTheme.spacingS),

                    // Baris Waktu Terbit & Tombol Bookmark
                    Row(
                      children: [
                        const Icon(
                          Icons.schedule_rounded,
                          size: AppTheme.iconSizeXs,
                          color: AppTheme.textSecondary,
                        ),
                        const SizedBox(width: AppTheme.spacingXs),
                        Expanded(
                          child: Text(
                            _formatPublishedDate(article.publishedAt),
                            style: AppTheme.labelStyle,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        ?trailingAction,
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(width: AppTheme.spacingM),

              // Kolom Kanan: Thumbnail Persegi 88x88
              ClipRRect(
                borderRadius: BorderRadius.circular(AppTheme.radiusS),
                child: hasImage
                    ? Image.network(
                        article.urlToImage!,
                        width: AppTheme.thumbnailSize,
                        height: AppTheme.thumbnailSize,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            _buildImagePlaceholder(
                          height: AppTheme.thumbnailSize,
                          width: AppTheme.thumbnailSize,
                        ),
                      )
                    : _buildImagePlaceholder(
                        height: AppTheme.thumbnailSize,
                        width: AppTheme.thumbnailSize,
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
