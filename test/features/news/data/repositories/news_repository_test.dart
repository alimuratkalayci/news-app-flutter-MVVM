import 'package:flutter_test/flutter_test.dart';
import 'package:news_app/features/news/data/models/news_model.dart';
import 'package:news_app/features/news/data/repositories/news_repository.dart';
import 'package:news_app/features/news/data/services/news_service.dart';

// Mock Service
class MockNewsService extends NewsService {
  NewsModel? mockData;
  Exception? mockError;

  @override
  Future<NewsModel> fetchNews({
    required String country,
    required String category,
  }) async {
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
  late NewsRepository repository;
  late MockNewsService mockService;

  setUp(() {
    mockService = MockNewsService();
    repository = NewsRepository(newsService: mockService);
  });

  group('NewsRepository', () {
    test('getNews should return NewsModel on success', () async {
      // Arrange
      final mockNews = NewsModel(
        status: 'ok',
        totalResults: 1,
        articles: [
          ArticleModel(
            source: SourceModel(name: 'Test Source'),
            title: 'Test Title',
            url: 'https://test.com',
            publishedAt: DateTime.now(),
          ),
        ],
      );
      mockService.mockData = mockNews;

      // Act
      final result = await repository.getNews(
        country: 'US',
        category: 'business',
      );

      // Assert
      expect(result, isA<NewsModel>());
      expect(result.status, 'ok');
      expect(result.articles.length, 1);
    });

    test('getNews should throw exception on error', () async {
      // Arrange
      mockService.mockError = Exception('Network error');

      // Act & Assert
      expect(
        () => repository.getNews(country: 'US', category: 'business'),
        throwsException,
      );
    });
  });
}

