import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../viewmodels/news_view_model.dart';
import '../widgets/custom_dropdown.dart';
import '../widgets/error_widget.dart';
import '../widgets/gradient_app_bar.dart' show ModernAppBar;
import '../widgets/news_card.dart';
import '../widgets/search_field.dart';
import '../widgets/empty_state_widget.dart';
import 'news_detail_page.dart';

class NewsPage extends StatefulWidget {
  const NewsPage({super.key});

  @override
  State<NewsPage> createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage> {
  late TextEditingController _searchController;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _scrollController.addListener(_onScroll);
    // Fetch initial news
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<NewsViewModel>().fetchNews();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!mounted || !_scrollController.hasClients) return;
    
    final position = _scrollController.position.pixels;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final viewModel = context.read<NewsViewModel>();
    
    // Son %80'e gelindiğinde yeni haberleri yükle
    if (position >= maxScroll * 0.8 && viewModel.hasMore && !viewModel.isLoadingMore) {
      viewModel.loadMore();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const ModernAppBar(title: 'News'),
      body: Consumer<NewsViewModel>(
        builder: (context, viewModel, child) {
          return RefreshIndicator(
            onRefresh: () => viewModel.refresh(),
            color: AppColors.secondary,
            child: CustomScrollView(
              controller: _scrollController,
              slivers: [
                // Filters Section
                SliverToBoxAdapter(
                  child: _buildFiltersSection(viewModel),
                ),
                // News List Section
                _buildNewsContent(viewModel),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildFiltersSection(NewsViewModel viewModel) {
    return Container(
      color: AppColors.background,
      padding: const EdgeInsets.all(AppDimensions.paddingMedium),
      child: Column(
        children: [
          // Country and Category Dropdowns
          Row(
            children: [
              CustomDropdown(
                label: 'Country',
                value: viewModel.selectedCountry,
                items: AppConstants.countries,
                onChanged: (value) {
                  if (value != null) {
                    viewModel.setCountry(value);
                  }
                },
              ),
              const SizedBox(width: AppDimensions.spacingMedium),
              CustomDropdown(
                label: 'Category',
                value: viewModel.selectedCategory,
                items: AppConstants.categories,
                onChanged: (value) {
                  if (value != null) {
                    viewModel.setCategory(value);
                  }
                },
              ),
            ],
          ),
          const SizedBox(height: AppDimensions.spacingMedium),
          // Search Field
          SearchField(
            controller: _searchController,
            onChanged: (query) => viewModel.setSearchQuery(query),
            onClear: () {
              _searchController.clear();
              viewModel.clearSearch();
            },
          ),
          const SizedBox(height: AppDimensions.spacingSmall),
        ],
      ),
    );
  }

  Widget _buildNewsContent(NewsViewModel viewModel) {
    if (viewModel.isLoading) {
      return const SliverFillRemaining(
        child: Center(
          child: CircularProgressIndicator(
            color: AppColors.secondary,
          ),
        ),
      );
    }

    if (viewModel.hasError) {
      return SliverFillRemaining(
        child: ErrorView(
          message: viewModel.errorMessage ?? 'Unknown error occurred',
          onRetry: () => viewModel.refresh(),
        ),
      );
    }

    if (viewModel.isEmpty) {
      return const SliverFillRemaining(
        child: EmptyStateWidget(),
      );
    }

    if (viewModel.articles.isEmpty && viewModel.searchQuery.isNotEmpty) {
      return const SliverFillRemaining(
        child: EmptyStateWidget(
          message: 'No articles found for your search',
        ),
      );
    }

    return SliverPadding(
      padding: const EdgeInsets.only(
        bottom: AppDimensions.paddingLarge,
      ),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            // Loading indicator for load more
            if (index == viewModel.articles.length) {
              if (viewModel.isLoadingMore) {
                return const Padding(
                  padding: EdgeInsets.all(AppDimensions.paddingMedium),
                  child: Center(
                    child: CircularProgressIndicator(
                      color: AppColors.secondary,
                    ),
                  ),
                );
              }
              if (viewModel.hasMore) {
                return Padding(
                  padding: const EdgeInsets.all(AppDimensions.paddingMedium),
                  child: Center(
                    child: ElevatedButton(
                      onPressed: () => viewModel.loadMore(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.secondary,
                        foregroundColor: AppColors.textWhite,
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppDimensions.paddingLarge,
                          vertical: AppDimensions.paddingMedium,
                        ),
                      ),
                      child: const Text('Load More'),
                    ),
                  ),
                );
              }
              return const SizedBox.shrink();
            }

            final article = viewModel.articles[index];
            return NewsCard(
              article: article,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => NewsDetailPage(
                      article: article,
                    ),
                  ),
                );
              },
            );
          },
          childCount: viewModel.articles.length + (viewModel.hasMore ? 1 : 0),
        ),
      ),
    );
  }
}

