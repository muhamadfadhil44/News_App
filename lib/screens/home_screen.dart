import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:news_app/providers/bookmark_provider.dart';
import 'package:news_app/providers/news_provider.dart';
import 'package:news_app/screens/bookmark_screen.dart';
import 'package:news_app/screens/detail_screen.dart';
import 'package:news_app/theme/app_theme.dart';
import 'package:news_app/widgets/article_card.dart';
import 'package:news_app/widgets/state_views.dart';

/// Layar Beranda utama aplikasi berita.
/// Dilengkapi dengan:
/// - Fitur pencarian artikel via kolom cari.
/// - Filter kategori berbasis chip (Semua, Teknologi, Bisnis, Olahraga, Pendidikan).
/// - 4 penanganan status jaringan (Loading, Sukses, Error, Kosong).
/// - Navigasi ke Layar Detail dan Layar Favorit.
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final TextEditingController _searchController;

  static const List<String> _categories = [
    'Semua',
    'Teknologi',
    'Bisnis',
    'Olahraga',
    'Pendidikan',
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Berita Terkini'),
        actions: [
          IconButton(
            icon: const Icon(Icons.bookmark_rounded),
            tooltip: 'Artikel Favorit',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const BookmarkScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // 1. Kolom Pencarian Berita
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppTheme.spacingM,
              AppTheme.spacingS,
              AppTheme.spacingM,
              AppTheme.spacingS,
            ),
            child: TextField(
              controller: _searchController,
              textInputAction: TextInputAction.search,
              decoration: InputDecoration(
                hintText: 'Cari topik atau judul berita...',
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
          ),

          // 2. Chip Kategori Berita
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
                            fontSize: AppTheme.fontSizeBody,
                            fontWeight: isSelected
                                ? FontWeight.bold
                                : FontWeight.normal,
                            color: isSelected
                                ? AppTheme.onPrimary
                                : AppTheme.textPrimary,
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

          const SizedBox(height: AppTheme.spacingS),

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
                    onRetry: () => provider.refreshArticles(),
                  );
                }

                // State 3: Kosong (Empty)
                if (provider.isEmpty) {
                  final hasQuery = provider.searchQuery.isNotEmpty;
                  final emptyMessage = hasQuery
                      ? 'Tidak ada berita yang cocok dengan kata kunci "${provider.searchQuery}".'
                      : 'Belum ada artikel berita untuk kategori ${provider.selectedCategory}.';

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
                      return ArticleCard(
                        article: article,
                        trailingAction: Consumer<BookmarkProvider>(
                          builder: (context, bookmarkProvider, child) {
                            final isFav =
                                bookmarkProvider.isBookmarked(article);
                            return IconButton(
                              icon: Icon(
                                isFav
                                    ? Icons.bookmark_rounded
                                    : Icons.bookmark_outline_rounded,
                                color: isFav
                                    ? AppTheme.primary
                                    : AppTheme.textSecondary,
                              ),
                              tooltip: isFav
                                  ? 'Hapus dari favorit'
                                  : 'Simpan ke favorit',
                              onPressed: () {
                                final added = bookmarkProvider
                                    .toggleBookmark(article);
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
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  DetailScreen(article: article),
                            ),
                          );
                        },
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
