import 'package:flutter/material.dart';

/// Konfigurasi tema terpusat untuk News App.
/// Sesuai aturan PRD dan AGENTS.md:
/// - Menggunakan Material 3.
/// - Satu warna utama dan warna netral.
/// - Dua tingkat tipografi: judul dan isi.
/// - Jarak antar elemen menggunakan kelipatan 8.
/// - Semua warna, ukuran teks, dan jarak di widget wajib diambil dari kelas ini.
class AppTheme {
  AppTheme._();

  // ==========================================
  // PALET WARNA (Colors)
  // ==========================================
  /// Warna utama aplikasi (Deep Blue)
  static const Color primary = Color(0xFF1E3A8A);

  /// Warna pendukung kontainer utama
  static const Color primaryContainer = Color(0xFFDBEAFE);

  /// Warna teks di atas warna utama
  static const Color onPrimary = Colors.white;

  /// Warna netral latar belakang aplikasi (Scaffold)
  static const Color background = Color(0xFFF8FAFC);

  /// Warna permukaan untuk kartu atau komponen UI (Surface)
  static const Color surface = Colors.white;

  /// Warna teks utama (untuk judul dan teks tebal)
  static const Color textPrimary = Color(0xFF0F172A);

  /// Warna teks sekunder (untuk isi berita, penulis, tanggal)
  static const Color textSecondary = Color(0xFF64748B);

  /// Warna garis batas (border) dan pemisah (divider)
  static const Color border = Color(0xFFE2E8F0);

  /// Warna placeholder gambar atau abu-abu netral
  static const Color placeholder = Color(0xFFCBD5E1);

  /// Warna indikator pesan error atau kegagalan
  static const Color error = Color(0xFFDC2626);

  /// Warna latar belakang kontainer error
  static const Color errorContainer = Color(0xFFFEE2E2);

  // ==========================================
  // JARAK DAN SPACING (Kelipatan 8)
  // ==========================================
  static const double spacingXs = 4.0;
  static const double spacingS = 8.0;
  static const double spacingM = 16.0;
  static const double spacingL = 24.0;
  static const double spacingXl = 32.0;
  static const double spacingXxl = 40.0;

  // Radius kelipatan 8
  static const double radiusS = 8.0;
  static const double radiusM = 16.0;

  // ==========================================
  // TIPOGRAFI (Dua Tingkat: Judul & Isi)
  // ==========================================
  static const double fontSizeTitle = 18.0;
  static const FontWeight fontWeightTitle = FontWeight.bold;

  static const double fontSizeBody = 14.0;
  static const FontWeight fontWeightBody = FontWeight.normal;

  /// Gaya teks untuk judul (headline/title)
  static const TextStyle titleStyle = TextStyle(
    fontSize: fontSizeTitle,
    fontWeight: fontWeightTitle,
    color: textPrimary,
    height: 1.3,
  );

  /// Gaya teks untuk isi (body/description)
  static const TextStyle bodyStyle = TextStyle(
    fontSize: fontSizeBody,
    fontWeight: fontWeightBody,
    color: textSecondary,
    height: 1.5,
  );

  // ==========================================
  // ThemeData (Material 3)
  // ==========================================
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: const ColorScheme(
        brightness: Brightness.light,
        primary: primary,
        onPrimary: onPrimary,
        primaryContainer: primaryContainer,
        onPrimaryContainer: primary,
        secondary: primary,
        onSecondary: onPrimary,
        error: error,
        onError: Colors.white,
        errorContainer: errorContainer,
        onErrorContainer: error,
        surface: surface,
        onSurface: textPrimary,
      ),
      scaffoldBackgroundColor: background,
      appBarTheme: const AppBarTheme(
        backgroundColor: surface,
        foregroundColor: textPrimary,
        elevation: 0,
        scrolledUnderElevation: 0.5,
        centerTitle: false,
        titleTextStyle: TextStyle(
          fontSize: fontSizeTitle,
          fontWeight: fontWeightTitle,
          color: textPrimary,
        ),
        iconTheme: IconThemeData(color: textPrimary),
      ),
      textTheme: const TextTheme(
        // Tingkat 1: Judul
        titleLarge: titleStyle,
        titleMedium: titleStyle,
        // Tingkat 2: Isi
        bodyMedium: bodyStyle,
        bodySmall: TextStyle(
          fontSize: fontSizeBody,
          fontWeight: fontWeightBody,
          color: textSecondary,
        ),
      ),
      cardTheme: CardThemeData(
        color: surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusS),
          side: const BorderSide(color: border),
        ),
        margin: EdgeInsets.zero,
      ),
      dividerTheme: const DividerThemeData(
        color: border,
        thickness: 1,
        space: spacingS,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: onPrimary,
          elevation: 0,
          padding: const EdgeInsets.symmetric(
            horizontal: spacingM,
            vertical: spacingS,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radiusS),
          ),
          textStyle: const TextStyle(
            fontSize: fontSizeBody,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: primary,
          side: const BorderSide(color: primary),
          padding: const EdgeInsets.symmetric(
            horizontal: spacingM,
            vertical: spacingS,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radiusS),
          ),
          textStyle: const TextStyle(
            fontSize: fontSizeBody,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
