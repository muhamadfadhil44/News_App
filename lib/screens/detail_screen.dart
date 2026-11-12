import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:news_app/models/article.dart';
import 'package:news_app/providers/bookmark_provider.dart';
import 'package:news_app/theme/app_theme.dart';

/// Layar Detail Berita bergaya editorial "Nusantara Post" (Stitch Design).
/// Sesuai PRD Fitur 3:
/// - Gambar artikel dengan placeholder jika kosong atau gagal dimuat.
/// - Judul berita bergaya editorial serif.
/// - Kotak metadata penulis, sumber berita, dan tanggal publikasi.
/// - Deskripsi dan konten artikel.
/// - Tombol "Baca Selengkapnya" untuk membuka tautan berita asli lewat url_launcher.
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

  /// Mengambil inisial nama penulis untuk ditampilkan pada avatar kotak metadata.
  String _getAuthorInitials(String? author) {
    if (author == null || author.trim().isEmpty) {
      return 'NP';
    }
    final parts = author.trim().split(RegExp(r'\s+'));
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return parts[0].substring(0, parts[0].length >= 2 ? 2 : 1).toUpperCase();
  }

  /// Placeholder saat gambar artikel tidak tersedia atau gagal dimuat.
  Widget _buildImagePlaceholder() {
    return Container(
      height: AppTheme.detailImageHeight,
      width: double.infinity,
      color: AppTheme.placeholder,
      child: const Center(
        child: Icon(
          Icons.image_not_supported_outlined,
          color: AppTheme.textSecondary,
          size: AppTheme.spacingXxl,
        ),
      ),
    );
  }

  /// Membuka tautan artikel di browser eksternal secara asinkron menggunakan async/await.
  Future<void> bukaArtikel(BuildContext context, String url) async {
    final berhasil = await launchUrl(
      Uri.parse(url),
      mode: LaunchMode.externalApplication,
    );

    if (!berhasil && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Tidak bisa membuka tautan artikel.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final hasImage =
        article.urlToImage != null && article.urlToImage!.trim().isNotEmpty;
    final hasDescription =
        article.description != null && article.description!.trim().isNotEmpty;
    final hasContent =
        article.content != null && article.content!.trim().isNotEmpty;

    return Scaffold(
      appBar: AppBar(
        titleSpacing: AppTheme.spacingXs,
        title: Row(
          children: [
            Container(
              width: AppTheme.spacingL + AppTheme.spacingXs,
              height: AppTheme.spacingL + AppTheme.spacingXs,
              decoration: BoxDecoration(
                color: AppTheme.primaryContainer,
                borderRadius: BorderRadius.circular(AppTheme.radiusXs),
              ),
              child: const Center(
                child: Icon(
                  Icons.newspaper_rounded,
                  color: AppTheme.onPrimary,
                  size: AppTheme.iconSizeS,
                ),
              ),
            ),
            const SizedBox(width: AppTheme.spacingS),
            const Expanded(
              child: Text(
                'Detail Berita',
                style: AppTheme.cardTitleStyle,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        actions: [
          // Consumer mendengarkan status bookmark artikel ini di memori
          Consumer<BookmarkProvider>(
            builder: (context, bookmarkProvider, child) {
              final isFav = bookmarkProvider.isBookmarked(article);
              return IconButton(
                icon: Icon(
                  isFav
                      ? Icons.bookmark_rounded
                      : Icons.bookmark_outline_rounded,
                  color: isFav ? AppTheme.secondary : AppTheme.textPrimary,
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
            // Garis Aksen Progres Bacaan Editorial
            Container(
              width: double.infinity,
              height: AppTheme.progressBarHeight,
              color: AppTheme.surfaceContainer,
              alignment: Alignment.centerLeft,
              child: FractionallySizedBox(
                widthFactor: 0.35,
                child: Container(
                  height: AppTheme.progressBarHeight,
                  color: AppTheme.secondary,
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(AppTheme.spacingM),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 1. Toolbar Atas: Badge Sumber Berita & Estimasi Waktu Baca
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppTheme.spacingS,
                          vertical: AppTheme.spacingXs,
                        ),
                        decoration: BoxDecoration(
                          color: AppTheme.surfaceContainerHigh,
                          borderRadius:
                              BorderRadius.circular(AppTheme.radiusXs),
                        ),
                        child: Text(
                          article.sourceName ?? 'Sumber Umum',
                          style: AppTheme.sourceTagStyle.copyWith(
                            color: AppTheme.textSecondary,
                          ),
                        ),
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
                            'Waktu baca: 4 menit',
                            style: AppTheme.labelStyle,
                          ),
                        ],
                      ),
                    ],
                  ),

                  const SizedBox(height: AppTheme.spacingS),

                  // 2. Judul Utama Editorial (Headline XL)
                  Text(
                    article.title,
                    style: AppTheme.headlineLargeStyle,
                  ),

                  // 3. Lead / Deskripsi Berita
                  if (hasDescription) ...[
                    const SizedBox(height: AppTheme.spacingS),
                    Text(
                      article.description!,
                      style: AppTheme.bodyStyle.copyWith(
                        color: AppTheme.textSecondary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],

                  const SizedBox(height: AppTheme.spacingSm),

                  // 4. Kotak Byline & Metadata Redaksi (Sesuai Desain Stitch)
                  Container(
                    padding: const EdgeInsets.all(AppTheme.spacingSm),
                    decoration: BoxDecoration(
                      color: AppTheme.surfaceContainerLow,
                      borderRadius: BorderRadius.circular(AppTheme.radiusS),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: AppTheme.avatarSize,
                              height: AppTheme.avatarSize,
                              decoration: const BoxDecoration(
                                color: AppTheme.primary,
                                shape: BoxShape.circle,
                              ),
                              child: Center(
                                child: Text(
                                  _getAuthorInitials(article.author),
                                  style: AppTheme.subHeaderLabelStyle.copyWith(
                                    color: AppTheme.onPrimary,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: AppTheme.spacingS),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    article.author != null &&
                                            article.author!.trim().isNotEmpty
                                        ? 'Oleh: ${article.author}'
                                        : 'Penulis: Tidak disebutkan',
                                    style: AppTheme.bodyStyle.copyWith(
                                      color: AppTheme.textPrimary,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const Text(
                                    'Biro Redaksi Nusantara Post',
                                    style: AppTheme.labelStyle,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: AppTheme.spacingXs),
                        const Divider(),
                        Row(
                          children: [
                            const Icon(
                              Icons.calendar_today_rounded,
                              size: AppTheme.iconSizeXs,
                              color: AppTheme.textSecondary,
                            ),
                            const SizedBox(width: AppTheme.spacingXs),
                            Text(
                              _formatPublishedDate(article.publishedAt),
                              style: AppTheme.labelStyle,
                            ),
                            const SizedBox(width: AppTheme.spacingM),
                            const Text(
                              'Edisi Terverifikasi',
                              style: AppTheme.sourceTagStyle,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: AppTheme.spacingSm),

                  // 5. Foto Utama Artikel dengan Caption Editorial
                  ClipRRect(
                    borderRadius: BorderRadius.circular(AppTheme.radiusS),
                    child: hasImage
                        ? Image.network(
                            article.urlToImage!,
                            height: AppTheme.detailImageHeight,
                            width: double.infinity,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                _buildImagePlaceholder(),
                          )
                        : _buildImagePlaceholder(),
                  ),
                  if (hasImage) ...[
                    const SizedBox(height: AppTheme.spacingXs),
                    Text(
                      'Ilustrasi liputan berita ${article.sourceName ?? 'Nusantara Post'}.',
                      style: AppTheme.labelStyle.copyWith(
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],

                  const SizedBox(height: AppTheme.spacingSm),

                  // 6. Isi Konten Artikel
                  if (hasContent) ...[
                    Text(
                      article.content!,
                      style: AppTheme.bodyLargeStyle,
                    ),
                    const SizedBox(height: AppTheme.spacingM),
                  ] else if (!hasDescription) ...[
                    const Text(
                      'Tidak ada rincian konten tambahan untuk berita ini.',
                      style: AppTheme.bodyStyle,
                    ),
                    const SizedBox(height: AppTheme.spacingSm),
                  ],

                  // 7. Kotak Liputan Sumber & Tombol Baca Selengkapnya
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(AppTheme.spacingSm),
                    decoration: BoxDecoration(
                      color: AppTheme.surfaceContainer,
                      borderRadius: BorderRadius.circular(AppTheme.radiusS),
                      border: const Border(
                        left: BorderSide(
                          color: AppTheme.secondary,
                          width: AppTheme.sectionBarWidth,
                        ),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'LIPUTAN LENGKAP',
                          style: AppTheme.sourceTagStyle,
                        ),
                        const SizedBox(height: AppTheme.spacingXs),
                        const Text(
                          'Baca laporan selengkapnya langsung melalui portal resmi sumber berita.',
                          style: AppTheme.bodyStyle,
                        ),
                        const SizedBox(height: AppTheme.spacingM),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: () {
                              if (article.url != null &&
                                  article.url!.trim().isNotEmpty) {
                                bukaArtikel(context, article.url!);
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'Aksi membuka tautan web akan dipasang pada tahap integrasi API.',
                                    ),
                                  ),
                                );
                              }
                            },
                            icon: const Icon(
                              Icons.open_in_browser_rounded,
                              size: AppTheme.iconSizeM,
                            ),
                            label: const Text('Baca Selengkapnya'),
                          ),
                        ),
                      ],
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
