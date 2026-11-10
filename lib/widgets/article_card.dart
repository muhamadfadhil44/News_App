import 'package:flutter/material.dart';
import 'package:news_app/models/article.dart';
import 'package:news_app/theme/app_theme.dart';

/// Komponen kartu artikel yang dapat digunakan ulang di Beranda dan Favorit.
///
/// Fitur:
/// - Menampilkan gambar dengan placeholder jika URL null atau gagal dimuat.
/// - Menampilkan nama sumber, tanggal terbit, dan judul berita.
/// - Menangani nilai null secara aman pada seluruh field artikel.
/// - Seluruh styling warna, tipografi, dan jarak mengacu ke [AppTheme].
class ArticleCard extends StatelessWidget {
  final Article article;
  final VoidCallback? onTap;
  final Widget? trailingAction;

  const ArticleCard({
    super.key,
    required this.article,
    this.onTap,
    this.trailingAction,
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
  Widget _buildImagePlaceholder() {
    return Container(
      height: 180,
      width: double.infinity,
      color: AppTheme.border,
      child: const Center(
        child: Icon(
          Icons.image_not_supported_outlined,
          color: AppTheme.textSecondary,
          size: AppTheme.spacingXl,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final hasImage =
        article.urlToImage != null && article.urlToImage!.trim().isNotEmpty;

    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppTheme.radiusS),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Bagian Gambar Artikel dengan penanganan placeholder
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(AppTheme.radiusS),
              ),
              child: hasImage
                  ? Image.network(
                      article.urlToImage!,
                      height: 180,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          _buildImagePlaceholder(),
                    )
                  : _buildImagePlaceholder(),
            ),

            // Bagian Konten Teks
            Padding(
              padding: const EdgeInsets.all(AppTheme.spacingM),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Baris Sumber Berita dan Waktu Terbit
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          article.sourceName ?? 'Sumber Umum',
                          style: const TextStyle(
                            fontSize: AppTheme.fontSizeBody,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.primary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: AppTheme.spacingS),
                      Text(
                        _formatPublishedDate(article.publishedAt),
                        style: AppTheme.bodyStyle,
                      ),
                      if (trailingAction != null) ...[
                        const SizedBox(width: AppTheme.spacingS),
                        trailingAction!,
                      ],
                    ],
                  ),

                  const SizedBox(height: AppTheme.spacingS),

                  // Judul Berita
                  Text(
                    article.title,
                    style: AppTheme.titleStyle,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),

                  // Deskripsi Berita Singkat (jika ada)
                  if (article.description != null &&
                      article.description!.trim().isNotEmpty) ...[
                    const SizedBox(height: AppTheme.spacingS),
                    Text(
                      article.description!,
                      style: AppTheme.bodyStyle,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
