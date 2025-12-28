import 'package:flutter_test/flutter_test.dart';
import 'package:news_app/core/constants/app_constants.dart';
import 'package:news_app/features/news/data/models/news_model.dart';
import 'package:news_app/features/news/data/repositories/news_repository.dart';
import 'package:news_app/features/news/presentation/viewmodels/news_view_model.dart';

// Mock Repository
class MockNewsRepository extends NewsRepository {
  NewsModel? mockData;
  Exception? mockError;
  bool shouldDelay = false;

  MockNewsRepository() : super();

  @override
  Future<NewsModel> getNews({
    required String country,
    required String category,
  }) async {
    if (shouldDelay) {
      await Future.delayed(const Duration(milliseconds: 100));
    }
    if (mockError != null) {
      throw mockError!;
    }
    if (mockData != null) {
      return mockData!;
    }
    throw Exception('Mock data not set');
  }
}

void main() {
  late NewsViewModel viewModel;
  late MockNewsRepository mockRepository;

  setUp(() {
    mockRepository = MockNewsRepository();
    viewModel = NewsViewModel(repository: mockRepository);
  });

  group('NewsViewModel - Initial State', () {
    test('should have initial state', () {
      expect(viewModel.status, NewsStatus.initial);
      expect(viewModel.newsData, isNull);
      expect(viewModel.errorMessage, isNull);
      expect(viewModel.selectedCountry, AppConstants.defaultCountry);
      expect(viewModel.selectedCategory, AppConstants.defaultCategory);
      expect(viewModel.searchQuery, isEmpty);
      expect(viewModel.articles, isEmpty);
    });

    test('should have correct initial flags', () {
      expect(viewModel.isLoading, false);
      expect(viewModel.isLoaded, false);
      expect(viewModel.hasError, false);
      expect(viewModel.isEmpty, false);
      expect(viewModel.hasMore, false);
    });
  });

  group('NewsViewModel - fetchNews', () {
    test('should fetch news successfully', () async {
      // Arrange
      final mockNews = NewsModel(
        status: 'ok',
        totalResults: 5,
        articles: List.generate(
          5,
          (index) => ArticleModel(
            source: SourceModel(name: 'Source $index'),
            title: 'Title $index',
            url: 'https://test.com/$index',
            publishedAt: DateTime.now(),
          ),
        ),
      );
      mockRepository.mockData = mockNews;

      // Act
      await viewModel.fetchNews();

      // Assert
      expect(viewModel.status, NewsStatus.loaded);
      expect(viewModel.newsData, isNotNull);
      expect(viewModel.articles.length, 3); // First page shows 3 items
      expect(viewModel.hasMore, true);
    });

    test('should handle error when fetching news', () async {
      // Arrange
      mockRepository.mockError = Exception('Network error');

      // Act
      await viewModel.fetchNews();

      // Assert
      expect(viewModel.status, NewsStatus.error);
      expect(viewModel.hasError, true);
      expect(viewModel.errorMessage, isNotNull);
      expect(viewModel.newsData, isNull);
    });

    test('should reset display count when fetching new news', () async {
      // Arrange
      final mockNews = NewsModel(
        status: 'ok',
        totalResults: 5,
        articles: List.generate(5, (index) => ArticleModel(
          source: SourceModel(name: 'Source'),
          title: 'Title $index',
          url: 'https://test.com',
          publishedAt: DateTime.now(),
        )),
      );
      mockRepository.mockData = mockNews;

      // Act
      await viewModel.fetchNews();
      await viewModel.loadMore(); // Load more to increase count
      await viewModel.fetchNews(); // Fetch again

      // Assert
      expect(viewModel.articles.length, 3); // Should reset to 3
    });
  });

  group('NewsViewModel - setCountry', () {
    test('should change country and fetch news', () async {
      // Arrange
      final mockNews = NewsModel(
        status: 'ok',
        totalResults: 1,
        articles: [
          ArticleModel(
            source: SourceModel(name: 'Source'),
            title: 'Title',
            url: 'https://test.com',
            publishedAt: DateTime.now(),
          ),
        ],
      );
      mockRepository.mockData = mockNews;

      // Act
      viewModel.setCountry('TR');

      // Wait for async operation
      await Future.delayed(const Duration(milliseconds: 150));

      // Assert
      expect(viewModel.selectedCountry, 'TR');
    });

    test('should not fetch if country is same', () async {
      // Arrange
      viewModel.setCountry(AppConstants.defaultCountry);

      // Act
      viewModel.setCountry(AppConstants.defaultCountry);

      // Assert - No exception should be thrown
      expect(viewModel.selectedCountry, AppConstants.defaultCountry);
    });
  });

  group('NewsViewModel - setCategory', () {
    test('should change category and fetch news', () async {
      // Arrange
      final mockNews = NewsModel(
        status: 'ok',
        totalResults: 1,
        articles: [
          ArticleModel(
            source: SourceModel(name: 'Source'),
            title: 'Title',
            url: 'https://test.com',
            publishedAt: DateTime.now(),
          ),
        ],
      );
      mockRepository.mockData = mockNews;

      // Act
      viewModel.setCategory('technology');

      // Wait for async operation
      await Future.delayed(const Duration(milliseconds: 150));

      // Assert
      expect(viewModel.selectedCategory, 'technology');
    });
  });

  group('NewsViewModel - Search', () {
    test('should filter articles by search query', () async {
      // Arrange
      final mockNews = NewsModel(
        status: 'ok',
        totalResults: 3,
        articles: [
          ArticleModel(
            source: SourceModel(name: 'Tech Source'),
            title: 'Technology News',
            description: 'Tech description',
            url: 'https://test.com/1',
            publishedAt: DateTime.now(),
          ),
          ArticleModel(
            source: SourceModel(name: 'Sports Source'),
            title: 'Sports News',
            description: 'Sports description',
            url: 'https://test.com/2',
            publishedAt: DateTime.now(),
          ),
          ArticleModel(
            source: SourceModel(name: 'Business Source'),
            title: 'Business News',
            description: 'Business description',
            url: 'https://test.com/3',
            publishedAt: DateTime.now(),
          ),
        ],
      );
      mockRepository.mockData = mockNews;
      await viewModel.fetchNews();

      // Act
      viewModel.setSearchQuery('Tech');

      // Assert
      expect(viewModel.searchQuery, 'Tech');
      expect(viewModel.articles.length, 1);
      expect(viewModel.articles[0].title, 'Technology News');
    });

    test('should clear search', () async {
      // Arrange
      final mockNews = NewsModel(
        status: 'ok',
        totalResults: 5,
        articles: List.generate(5, (index) => ArticleModel(
          source: SourceModel(name: 'Source'),
          title: 'Title $index',
          url: 'https://test.com',
          publishedAt: DateTime.now(),
        )),
      );
      mockRepository.mockData = mockNews;
      await viewModel.fetchNews();
      viewModel.setSearchQuery('test');

      // Act
      viewModel.clearSearch();

      // Assert
      expect(viewModel.searchQuery, isEmpty);
      expect(viewModel.articles.length, 3); // Should show first page (3 items)
    });
  });

  group('NewsViewModel - Pagination', () {
    test('should load more articles', () async {
      // Arrange
      final mockNews = NewsModel(
        status: 'ok',
        totalResults: 10,
        articles: List.generate(10, (index) => ArticleModel(
          source: SourceModel(name: 'Source'),
          title: 'Title $index',
          url: 'https://test.com/$index',
          publishedAt: DateTime.now(),
        )),
      );
      mockRepository.mockData = mockNews;
      await viewModel.fetchNews();

      // Act
      await viewModel.loadMore();

      // Assert
      expect(viewModel.articles.length, 6); // 3 + 3
      expect(viewModel.hasMore, true);
    });

    test('should not load more if no more articles', () async {
      // Arrange
      final mockNews = NewsModel(
        status: 'ok',
        totalResults: 2,
        articles: List.generate(2, (index) => ArticleModel(
          source: SourceModel(name: 'Source'),
          title: 'Title $index',
          url: 'https://test.com',
          publishedAt: DateTime.now(),
        )),
      );
      mockRepository.mockData = mockNews;
      await viewModel.fetchNews();

      // Act
      await viewModel.loadMore();

      // Assert
      expect(viewModel.articles.length, 2);
      expect(viewModel.hasMore, false);
    });

    test('should not load more if already loading', () async {
      // Arrange
      final mockNews = NewsModel(
        status: 'ok',
        totalResults: 10,
        articles: List.generate(10, (index) => ArticleModel(
          source: SourceModel(name: 'Source'),
          title: 'Title $index',
          url: 'https://test.com',
          publishedAt: DateTime.now(),
        )),
      );
      mockRepository.mockData = mockNews;
      await viewModel.fetchNews();

      // Act
      final future1 = viewModel.loadMore();
      final future2 = viewModel.loadMore(); // Second call should be ignored

      await future1;
      await future2;

      // Assert
      expect(viewModel.articles.length, 6); // Should only load once
    });
  });

  group('NewsViewModel - Refresh', () {
    test('should refresh news', () async {
      // Arrange
      final mockNews = NewsModel(
        status: 'ok',
        totalResults: 1,
        articles: [
          ArticleModel(
            source: SourceModel(name: 'Source'),
            title: 'Title',
            url: 'https://test.com',
            publishedAt: DateTime.now(),
          ),
        ],
      );
      mockRepository.mockData = mockNews;

      // Act
      await viewModel.refresh();

      // Assert
      expect(viewModel.status, NewsStatus.loaded);
      expect(viewModel.newsData, isNotNull);
    });
  });
}

