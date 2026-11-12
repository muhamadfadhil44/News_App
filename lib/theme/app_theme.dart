import 'package:flutter/material.dart';

/// Konfigurasi tema terpusat untuk News App (Gaya Editorial "Nusantara Post" dari Stitch).
/// Sesuai aturan PRD dan AGENTS.md:
/// - Menggunakan Material 3.
/// - Palet warna editorial: Hitam/Navy utama, Merah aksen, dan Abu-abu kertas netral.
/// - Dua tingkat tipografi utama: Judul (Serif Editorial) dan Isi (Sans-serif bersih).
/// - Jarak antar elemen menggunakan skala terpusat.
/// - Semua warna, ukuran teks, dan jarak di widget wajib diambil dari kelas ini.
class AppTheme {
  AppTheme._();

  // ==========================================
  // PALET WARNA EDITORIAL (Stitch Nusantara Post)
  // ==========================================
  /// Warna utama aplikasi (Editorial Black)
  static const Color primary = Color(0xFF000000);

  /// Warna kontainer utama gelap (Deep Editorial Navy)
  static const Color primaryContainer = Color(0xFF0E1D2A);

  /// Warna teks di atas warna utama
  static const Color onPrimary = Color(0xFFFFFFFF);

  /// Warna teks sekunder di atas kontainer utama gelap
  static const Color onPrimaryContainer = Color(0xFFB9C8DA);

  /// Warna aksen merah editorial khas Nusantara Post (Crimson Red)
  static const Color secondary = Color(0xFFBB0413);

  /// Warna teks di atas warna aksen sekunder
  static const Color onSecondary = Color(0xFFFFFFFF);

  /// Warna latar belakang utama aplikasi (Warm Paper Gray)
  static const Color background = Color(0xFFF8F9FA);

  /// Warna permukaan kartu dan input (Pure White Surface)
  static const Color surface = Color(0xFFFFFFFF);

  /// Warna kontainer permukaan tingkat rendah (Byline box, bar aksi)
  static const Color surfaceContainerLow = Color(0xFFF3F4F5);

  /// Warna kontainer permukaan menengah (Chip tidak aktif, callout)
  static const Color surfaceContainer = Color(0xFFEDEEEF);

  /// Warna kontainer permukaan tinggi (Badge kategori, kutipan)
  static const Color surfaceContainerHigh = Color(0xFFE7E8E9);

  /// Warna teks utama (On-Surface Charcoal)
  static const Color textPrimary = Color(0xFF191C1D);

  /// Warna teks sekunder (On-Surface Variant Slate)
  static const Color textSecondary = Color(0xFF44474C);

  /// Warna teks petunjuk atau outline (Muted Outline)
  static const Color outline = Color(0xFF74777C);

  /// Warna garis batas (border) dan pemisah (divider)
  static const Color border = Color(0xFFE1E3E4);

  /// Warna placeholder gambar saat kosong atau gagal dimuat
  static const Color placeholder = Color(0xFFD9DADB);

  /// Warna indikator pesan error atau kegagalan
  static const Color error = Color(0xFFBA1A1A);

  /// Warna latar belakang kontainer error
  static const Color errorContainer = Color(0xFFFFDAD6);

  // ==========================================
  // JARAK, UKURAN, DAN RADIUS (Kelipatan 8 & Skala UI)
  // ==========================================
  static const double spacingXxs = 2.0;
  static const double spacingXs = 4.0;
  static const double spacingS = 8.0;
  static const double spacingSm = 12.0;
  static const double spacingM = 16.0;
  static const double spacingL = 24.0;
  static const double spacingXl = 32.0;
  static const double spacingXxl = 40.0;

  // Radius sudut komponen
  static const double radiusXs = 4.0;
  static const double radiusS = 8.0;
  static const double radiusM = 12.0;
  static const double radiusL = 16.0;
  static const double radiusFull = 999.0;

  // Ukuran komponen standar
  static const double thumbnailSize = 88.0;
  static const double breakingThumbnailSize = 76.0;
  static const double featuredImageHeight = 120.0;
  static const double detailImageHeight = 152.0;
  static const double avatarSize = 36.0;
  static const double badgeDotSize = 8.0;
  static const double sectionBarWidth = 4.0;
  static const double sectionBarHeight = 18.0;
  static const double progressBarHeight = 3.0;

  // Ukuran ikon standar
  static const double iconSizeXs = 14.0;
  static const double iconSizeS = 16.0;
  static const double iconSizeM = 20.0;
  static const double iconSizeL = 24.0;
  static const double iconSizeXl = 32.0;

  // ==========================================
  // TIPOGRAFI EDITORIAL (Dua Tingkat: Judul & Isi)
  // ==========================================
  /// Font keluarga serif untuk nuansa surat kabar editorial (Newsreader fallback)
  static const String fontFamilyEditorial = 'Georgia';

  static const double fontSizeHeadlineXl = 24.0;
  static const double fontSizeTitle = 18.0;
  static const double fontSizeCardTitle = 16.0;
  static const FontWeight fontWeightTitle = FontWeight.bold;

  static const double fontSizeBodyLg = 16.0;
  static const double fontSizeBody = 14.0;
  static const double fontSizeLabel = 12.0;
  static const double fontSizeLabelSm = 11.0;
  static const FontWeight fontWeightBody = FontWeight.normal;

  /// Gaya teks judul utama layar Detail (Headline XL)
  static const TextStyle headlineLargeStyle = TextStyle(
    fontFamily: fontFamilyEditorial,
    fontSize: fontSizeHeadlineXl,
    fontWeight: fontWeightTitle,
    color: textPrimary,
    height: 1.25,
    letterSpacing: -0.3,
  );

  /// Gaya teks untuk judul bagian & kartu sorotan utama (Headline MD/LG)
  static const TextStyle titleStyle = TextStyle(
    fontFamily: fontFamilyEditorial,
    fontSize: fontSizeTitle,
    fontWeight: fontWeightTitle,
    color: textPrimary,
    height: 1.3,
    letterSpacing: -0.2,
  );

  /// Gaya teks untuk judul kartu artikel daftar berita (Headline SM)
  static const TextStyle cardTitleStyle = TextStyle(
    fontFamily: fontFamilyEditorial,
    fontSize: fontSizeCardTitle,
    fontWeight: FontWeight.w700,
    color: textPrimary,
    height: 1.3,
  );

  /// Gaya teks nama surat kabar di AppBar ("Nusantara Post")
  static const TextStyle brandTitleStyle = TextStyle(
    fontFamily: fontFamilyEditorial,
    fontSize: fontSizeTitle,
    fontWeight: FontWeight.w700,
    color: primary,
    letterSpacing: -0.3,
    height: 1.1,
  );

  /// Gaya teks untuk isi artikel di layar Detail (Body Large)
  static const TextStyle bodyLargeStyle = TextStyle(
    fontFamily: fontFamilyEditorial,
    fontSize: fontSizeBodyLg,
    fontWeight: fontWeightBody,
    color: textPrimary,
    height: 1.65,
  );

  /// Gaya teks untuk isi/deskripsi umum (Body Standard)
  static const TextStyle bodyStyle = TextStyle(
    fontSize: fontSizeBody,
    fontWeight: fontWeightBody,
    color: textSecondary,
    height: 1.5,
  );

  /// Gaya teks untuk label metadata, waktu terbit, dan penulis
  static const TextStyle labelStyle = TextStyle(
    fontSize: fontSizeLabel,
    fontWeight: FontWeight.w500,
    color: textSecondary,
    height: 1.3,
  );

  /// Gaya teks untuk label sumber/kategori berwarna merah aksen
  static const TextStyle sourceTagStyle = TextStyle(
    fontSize: fontSizeLabelSm,
    fontWeight: FontWeight.w700,
    color: secondary,
    letterSpacing: 0.6,
    height: 1.2,
  );

  /// Gaya teks untuk subjudul bagian di bawah brand AppBar
  static const TextStyle subHeaderLabelStyle = TextStyle(
    fontSize: fontSizeLabelSm,
    fontWeight: FontWeight.w600,
    color: textSecondary,
    letterSpacing: 0.8,
    height: 1.2,
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
        onPrimaryContainer: onPrimaryContainer,
        secondary: secondary,
        onSecondary: onSecondary,
        error: error,
        onError: onPrimary,
        errorContainer: errorContainer,
        onErrorContainer: error,
        surface: surface,
        onSurface: textPrimary,
      ),
      scaffoldBackgroundColor: background,
      appBarTheme: const AppBarTheme(
        backgroundColor: background,
        foregroundColor: textPrimary,
        elevation: 0,
        scrolledUnderElevation: 0.5,
        centerTitle: false,
        titleTextStyle: titleStyle,
        iconTheme: IconThemeData(color: textPrimary),
      ),
      textTheme: const TextTheme(
        // Tingkat 1: Judul Editorial
        headlineLarge: headlineLargeStyle,
        titleLarge: titleStyle,
        titleMedium: cardTitleStyle,
        // Tingkat 2: Isi & Label
        bodyLarge: bodyLargeStyle,
        bodyMedium: bodyStyle,
        bodySmall: labelStyle,
      ),
      cardTheme: CardThemeData(
        color: surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusM),
          side: const BorderSide(color: border, width: 0.8),
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
            horizontal: spacingL,
            vertical: spacingSm,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radiusS),
          ),
          textStyle: const TextStyle(
            fontSize: fontSizeBody,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.3,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: primary,
          side: const BorderSide(color: primary),
          padding: const EdgeInsets.symmetric(
            horizontal: spacingL,
            vertical: spacingSm,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radiusS),
          ),
          textStyle: const TextStyle(
            fontSize: fontSizeBody,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surface,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: spacingM,
          vertical: spacingSm,
        ),
        hintStyle: const TextStyle(
          fontSize: fontSizeBody,
          color: outline,
        ),
        prefixIconColor: outline,
        suffixIconColor: outline,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusS),
          borderSide: const BorderSide(color: border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusS),
          borderSide: const BorderSide(color: border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusS),
          borderSide: const BorderSide(color: primary, width: 1.5),
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: surfaceContainer,
        selectedColor: primary,
        secondarySelectedColor: primary,
        showCheckmark: false,
        padding: const EdgeInsets.symmetric(
          horizontal: spacingSm,
          vertical: spacingXs,
        ),
        labelStyle: labelStyle,
        secondaryLabelStyle: const TextStyle(
          fontSize: fontSizeLabel,
          fontWeight: FontWeight.w700,
          color: onPrimary,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusFull),
          side: BorderSide.none,
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: primary,
        contentTextStyle: const TextStyle(
          fontSize: fontSizeBody,
          color: onPrimary,
        ),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusS),
        ),
      ),
    );
  }
}
