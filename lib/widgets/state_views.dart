import 'package:flutter/material.dart';
import 'package:news_app/theme/app_theme.dart';

/// Tampilan indikator saat proses memuat data (Loading State).
class LoadingView extends StatelessWidget {
  final String message;

  const LoadingView({
    super.key,
    this.message = 'Memuat berita...',
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.spacingL),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircularProgressIndicator(
              color: AppTheme.secondary,
              strokeWidth: AppTheme.progressBarHeight,
            ),
            const SizedBox(height: AppTheme.spacingM),
            Text(
              message,
              style: AppTheme.bodyStyle,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

/// Tampilan saat terjadi kesalahan atau kegagalan jaringan (Error State).
/// Dilengkapi tombol aksi untuk mencoba kembali (retry).
class ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const ErrorView({
    super.key,
    required this.message,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.spacingL),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: AppTheme.spacingXxl + AppTheme.spacingL,
              height: AppTheme.spacingXxl + AppTheme.spacingL,
              decoration: const BoxDecoration(
                color: AppTheme.errorContainer,
                shape: BoxShape.circle,
              ),
              child: const Center(
                child: Icon(
                  Icons.error_outline_rounded,
                  color: AppTheme.error,
                  size: AppTheme.iconSizeXl,
                ),
              ),
            ),
            const SizedBox(height: AppTheme.spacingM),
            const Text(
              'Terjadi Kesalahan',
              style: AppTheme.titleStyle,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppTheme.spacingS),
            Text(
              message.isNotEmpty ? message : 'Gagal memuat berita.',
              style: AppTheme.bodyStyle,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppTheme.spacingL),
            ElevatedButton.icon(
              onPressed: onRetry,
              icon: const Icon(
                Icons.refresh_rounded,
                size: AppTheme.iconSizeM,
              ),
              label: const Text('Coba Lagi'),
            ),
          ],
        ),
      ),
    );
  }
}

/// Tampilan saat respons berhasil tetapi data tidak ditemukan (Empty State).
/// Mengikuti gaya Empty State pada desain Stitch "Berita Tersimpan - Nusantara Post".
class EmptyView extends StatelessWidget {
  final String title;
  final String message;
  final VoidCallback? onRetry;
  final IconData icon;
  final String? actionLabel;

  const EmptyView({
    super.key,
    this.title = 'Belum Ada Berita',
    this.message = 'Tidak ada artikel berita yang tersedia saat ini.',
    this.onRetry,
    this.icon = Icons.bookmark_border_rounded,
    this.actionLabel,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.spacingL),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: AppTheme.spacingXxl + AppTheme.spacingL,
              height: AppTheme.spacingXxl + AppTheme.spacingL,
              decoration: const BoxDecoration(
                color: AppTheme.surfaceContainerHigh,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Icon(
                  icon,
                  color: AppTheme.outline,
                  size: AppTheme.iconSizeXl,
                ),
              ),
            ),
            const SizedBox(height: AppTheme.spacingM),
            Text(
              title,
              style: AppTheme.titleStyle,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppTheme.spacingS),
            Text(
              message,
              style: AppTheme.bodyStyle,
              textAlign: TextAlign.center,
            ),
            if (onRetry != null) ...[
              const SizedBox(height: AppTheme.spacingL),
              ElevatedButton.icon(
                onPressed: onRetry,
                icon: const Icon(
                  Icons.refresh_rounded,
                  size: AppTheme.iconSizeM,
                ),
                label: Text(actionLabel ?? 'Muat Ulang'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
