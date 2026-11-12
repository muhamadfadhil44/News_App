import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:news_app/models/article.dart';
import 'package:news_app/providers/bookmark_provider.dart';
import 'package:news_app/providers/news_provider.dart';
import 'package:news_app/screens/bookmark_screen.dart';
import 'package:news_app/screens/detail_screen.dart';
import 'package:news_app/theme/app_theme.dart';
import 'package:news_app/widgets/article_card.dart';
import 'package:news_app/widgets/state_views.dart';

/// Layar Beranda utama aplikasi berita bergaya editorial "Nusantara Post" (Stitch Design).
/// Dilengkapi dengan:
/// - Masthead editorial dan pencarian cepat.
/// - Filter kategori berbasis chip horizontal.
/// - Kartu Sorotan Utama dan daftar Liputan Terbaru.
/// - 4 penanganan status jaringan lewat Provider (Loading, Sukses, Error, Kosong).
/// - Navigasi ke Layar Detail dan Layar Berita Tersimpan (Bookmark).
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final TextEditingController _searchController;

  static const List<String> _categories = [
    'Semua',
    'Bisnis',
    'Teknologi',
    'Olahraga',
    'Pendidikan',
    'Kesehatan',
    'Hiburan',
  ];

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  /// Membuka layar Berita Tersimpan (BookmarkScreen).
  void _openBookmarkScreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const BookmarkScreen(),
      ),
    );
  }

  /// Membuka layar Detail Berita (DetailScreen).
  void _openDetailScreen(BuildContext context, Article article) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DetailScreen(article: article),
      ),
    );
  }

  /// Membangun tombol bookmark untuk setiap kartu artikel dengan memanfaatkan [BookmarkProvider].
  Widget _buildBookmarkAction(Article article) {
    // Consumer mendengarkan perubahan daftar bookmark di memori secara reaktif
    return Consumer<BookmarkProvider>(
      builder: (context, bookmarkProvider, child) {
        final isFav = bookmarkProvider.isBookmarked(article);
        return IconButton(
          visualDensity: VisualDensity.compact,
          icon: Icon(
            isFav ? Icons.bookmark_rounded : Icons.bookmark_outline_rounded,
            color: isFav ? AppTheme.secondary : AppTheme.textSecondary,
            size: AppTheme.iconSizeM,
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
    );
  }

  /// Membangun judul seksi dengan aksen garis vertikal khas editorial Stitch.
  Widget _buildSectionHeader({
    required String title,
    required Color accentColor,
    Widget? trailing,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Container(
              width: AppTheme.sectionBarWidth,
              height: AppTheme.sectionBarHeight,
              decoration: BoxDecoration(
                color: accentColor,
                borderRadius: BorderRadius.circular(AppTheme.radiusFull),
              ),
            ),
            const SizedBox(width: AppTheme.spacingS),
            Text(
              title,
              style: AppTheme.titleStyle,
            ),
          ],
        ),
        ?trailing,
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: AppTheme.spacingM,
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
                  'Berita Terkini',
                  style: AppTheme.subHeaderLabelStyle,
                ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.bookmark_rounded),
            tooltip: 'Artikel Favorit',
            onPressed: () => _openBookmarkScreen(context),
          ),
          Padding(
            padding: const EdgeInsets.only(right: AppTheme.spacingM),
            child: Container(
              width: AppTheme.spacingXl,
              height: AppTheme.spacingXl,
              decoration: const BoxDecoration(
                color: AppTheme.primary,
                shape: BoxShape.circle,
              ),
              child: const Center(
                child: Icon(
                  Icons.person_rounded,
                  color: AppTheme.onPrimary,
                  size: AppTheme.iconSizeS,
                ),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // 1. Sub-Bar Masthead Editorial & Kolom Pencarian
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppTheme.spacingM,
              AppTheme.spacingXs,
              AppTheme.spacingM,
              AppTheme.spacingS,
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'EDISI NUSANTARA',
                          style: AppTheme.subHeaderLabelStyle,
                        ),
                        Text(
                          'Jurnalisme Kredibel & Terpercaya',
                          style: AppTheme.labelStyle,
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppTheme.spacingSm,
                        vertical: AppTheme.spacingXs,
                      ),
                      decoration: BoxDecoration(
                        color: AppTheme.surfaceContainer,
                        borderRadius:
                            BorderRadius.circular(AppTheme.radiusFull),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: AppTheme.badgeDotSize,
                            height: AppTheme.badgeDotSize,
                            decoration: const BoxDecoration(
                              color: AppTheme.secondary,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: AppTheme.spacingXs),
                          const Text(
                            'EDISI PAGI',
                            style: AppTheme.sourceTagStyle,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppTheme.spacingSm),
                TextField(
                  controller: _searchController,
                  textInputAction: TextInputAction.search,
                  decoration: InputDecoration(
                    hintText: 'Cari berita, tokoh, atau peristiwa...',
                    prefixIcon: const Icon(Icons.search_rounded),
                    suffixIcon: _searchController.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear_rounded),
                            tooltip: 'Hapus pencarian',
                            onPressed: () {
                              _searchController.clear();
                              context.read<NewsProvider>().clearSearch();
                              setState(() {});
                            },
                          )
                        : null,
                  ),
                  onChanged: (value) {
                    setState(() {});
                    if (value.trim().isEmpty) {
                      context.read<NewsProvider>().clearSearch();
                    }
                  },
                  onSubmitted: (value) {
                    context.read<NewsProvider>().setSearchQuery(value.trim());
                  },
                ),
              ],
            ),
          ),

          // 2. Navigasi Kategori Horizontal
          Consumer<NewsProvider>(
            builder: (context, provider, child) {
              return SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(
                  horizontal: AppTheme.spacingM,
                  vertical: AppTheme.spacingXs,
                ),
                child: Row(
                  children: _categories.map((category) {
                    final isSelected = provider.selectedCategory == category;
                    return Padding(
                      padding: const EdgeInsets.only(right: AppTheme.spacingS),
                      child: FilterChip(
                        label: Text(
                          category,
                          style: TextStyle(
                            fontSize: AppTheme.fontSizeLabel,
                            fontWeight: isSelected
                                ? FontWeight.bold
                                : FontWeight.w500,
                            color: isSelected
                                ? AppTheme.onPrimary
                                : AppTheme.textSecondary,
                          ),
                        ),
                        selected: isSelected,
                        onSelected: (_) {
                          provider.setCategory(category);
                        },
                      ),
                    );
                  }).toList(),
                ),
              );
            },
          ),

          const SizedBox(height: AppTheme.spacingXs),

          // 3. Tampilan State Berita (Loading, Error, Empty, Success)
          Expanded(
            child: Consumer<NewsProvider>(
              builder: (context, provider, child) {
                // State 1: Loading
                if (provider.isLoading) {
                  return const LoadingView(
                    message: 'Memuat berita terbaru...',
                  );
                }

                // State 2: Error
                if (provider.isError) {
                  return ErrorView(
                    message: provider.errorMessage,
                    onRetry: () => provider.loadArticles(),
                  );
                }

                // State 3: Kosong (Empty)
                if (provider.isEmpty) {
                  final hasQuery = provider.searchQuery.isNotEmpty;
                  final emptyMessage = hasQuery
                      ? 'Tidak ada berita yang cocok dengan kata kunci "${provider.searchQuery}".'
                      : 'Belum ada artikel berita untuk kategori ${provider.selectedCategory}.';

                  // RefreshIndicator memanggil fungsi Future asinkron untuk memuat ulang berita
                  return RefreshIndicator(
                    onRefresh: () => provider.refreshArticles(),
                    child: ListView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      children: [
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.5,
                          child: EmptyView(
                            title: 'Belum Ada Berita',
                            message: emptyMessage,
                            icon: Icons.article_outlined,
                            onRetry: () {
                              _searchController.clear();
                              provider.clearSearch();
                              provider.setCategory('Semua');
                            },
                          ),
                        ),
                      ],
                    ),
                  );
                }

                // State 4: Sukses (Success)
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
                      final isFirst = index == 0;

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (isFirst) ...[
                            _buildSectionHeader(
                              title: 'Sorotan Utama',
                              accentColor: AppTheme.secondary,
                            ),
                            const SizedBox(height: AppTheme.spacingSm),
                          ] else if (index == 1) ...[
                            _buildSectionHeader(
                              title: 'Liputan Terbaru',
                              accentColor: AppTheme.primary,
                              trailing: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: AppTheme.spacingSm,
                                  vertical: AppTheme.spacingXs,
                                ),
                                decoration: BoxDecoration(
                                  color: AppTheme.surfaceContainer,
                                  borderRadius: BorderRadius.circular(
                                    AppTheme.radiusFull,
                                  ),
                                ),
                                child: const Text(
                                  'Urutkan: Terbaru',
                                  style: AppTheme.labelStyle,
                                ),
                              ),
                            ),
                            const SizedBox(height: AppTheme.spacingSm),
                          ],
                          ArticleCard(
                            article: article,
                            isFeatured: isFirst,
                            trailingAction: _buildBookmarkAction(article),
                            onTap: () => _openDetailScreen(context, article),
                          ),
                        ],
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
      // Navigasi Bawah Bergaya Editorial Stitch (Beranda & Bookmark)
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: AppTheme.surface,
          border: Border(
            top: BorderSide(color: AppTheme.border),
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppTheme.spacingL,
              vertical: AppTheme.spacingS,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                // Tab Aktif: Beranda
                InkWell(
                  borderRadius: BorderRadius.circular(AppTheme.radiusS),
                  onTap: () {},
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppTheme.spacingM,
                          vertical: AppTheme.spacingXxs,
                        ),
                        decoration: BoxDecoration(
                          color: AppTheme.primaryContainer,
                          borderRadius:
                              BorderRadius.circular(AppTheme.radiusFull),
                        ),
                        child: const Icon(
                          Icons.newspaper_rounded,
                          color: AppTheme.onPrimary,
                          size: AppTheme.iconSizeM,
                        ),
                      ),
                      const SizedBox(height: AppTheme.spacingXxs),
                      const Text(
                        'BERANDA',
                        style: AppTheme.subHeaderLabelStyle,
                      ),
                    ],
                  ),
                ),

                // Tab Navigasi: Bookmark
                Consumer<BookmarkProvider>(
                  builder: (context, bookmarkProvider, child) {
                    final hasBookmarks =
                        bookmarkProvider.bookmarkedArticles.isNotEmpty;
                    return InkWell(
                      borderRadius: BorderRadius.circular(AppTheme.radiusS),
                      onTap: () => _openBookmarkScreen(context),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Stack(
                            clipBehavior: Clip.none,
                            children: [
                              const Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: AppTheme.spacingM,
                                  vertical: AppTheme.spacingXxs,
                                ),
                                child: Icon(
                                  Icons.bookmark_border_rounded,
                                  color: AppTheme.textSecondary,
                                  size: AppTheme.iconSizeM,
                                ),
                              ),
                              if (hasBookmarks)
                                Positioned(
                                  top: 0,
                                  right: AppTheme.spacingSm,
                                  child: Container(
                                    width: AppTheme.badgeDotSize,
                                    height: AppTheme.badgeDotSize,
                                    decoration: const BoxDecoration(
                                      color: AppTheme.secondary,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                          const SizedBox(height: AppTheme.spacingXxs),
                          const Text(
                            'BOOKMARK',
                            style: AppTheme.subHeaderLabelStyle,
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
