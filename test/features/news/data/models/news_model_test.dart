import 'package:flutter_test/flutter_test.dart';
import 'package:news_app/features/news/data/models/news_model.dart';

void main() {
  group('NewsModel', () {
    test('fromJson should parse JSON correctly', () {
      // Arrange
      final json = {
        'status': 'ok',
        'totalResults': 2,
        'articles': [
          {
            'source': {'id': 'test-id', 'name': 'Test Source'},
            'author': 'Test Author',
            'title': 'Test Title',
            'description': 'Test Description',
            'url': 'https://test.com',
            'urlToImage': 'https://test.com/image.jpg',
            'publishedAt': '2024-01-01T00:00:00Z',
            'content': 'Test Content',
          },
        ],
      };

      // Act
      final news = NewsModel.fromJson(json);

      // Assert
      expect(news.status, 'ok');
      expect(news.totalResults, 2);
      expect(news.articles.length, 1);
      expect(news.articles[0].title, 'Test Title');
      expect(news.articles[0].author, 'Test Author');
    });

    test('fromJson should handle null values', () {
      // Arrange
      final json = {
        'status': 'ok',
        'totalResults': 0,
        'articles': [],
      };

      // Act
      final news = NewsModel.fromJson(json);

      // Assert
      expect(news.status, 'ok');
      expect(news.totalResults, 0);
      expect(news.articles, isEmpty);
    });

    test('toJson should convert to JSON correctly', () {
      // Arrange
      final article = ArticleModel(
        source: SourceModel(id: 'test-id', name: 'Test Source'),
        author: 'Test Author',
        title: 'Test Title',
        description: 'Test Description',
        url: 'https://test.com',
        urlToImage: 'https://test.com/image.jpg',
        publishedAt: DateTime.parse('2024-01-01T00:00:00Z'),
        content: 'Test Content',
      );

      final news = NewsModel(
        status: 'ok',
        totalResults: 1,
        articles: [article],
      );

      // Act
      final json = news.toJson();

      // Assert
      expect(json['status'], 'ok');
      expect(json['totalResults'], 1);
      expect(json['articles'], isA<List>());
    });
  });

  group('ArticleModel', () {
    test('fromJson should parse article correctly', () {
      // Arrange
      final json = {
        'source': {'id': 'test-id', 'name': 'Test Source'},
        'author': 'Test Author',
        'title': 'Test Title',
        'description': 'Test Description',
        'url': 'https://test.com',
        'urlToImage': 'https://test.com/image.jpg',
        'publishedAt': '2024-01-01T00:00:00Z',
        'content': 'Test Content',
      };

      // Act
      final article = ArticleModel.fromJson(json);

      // Assert
      expect(article.title, 'Test Title');
      expect(article.author, 'Test Author');
      expect(article.description, 'Test Description');
      expect(article.url, 'https://test.com');
      expect(article.source.name, 'Test Source');
    });

    test('fromJson should handle null optional fields', () {
      // Arrange
      final json = {
        'source': {'name': 'Test Source'},
        'title': 'Test Title',
        'url': 'https://test.com',
        'publishedAt': '2024-01-01T00:00:00Z',
      };

      // Act
      final article = ArticleModel.fromJson(json);

      // Assert
      expect(article.title, 'Test Title');
      expect(article.author, isNull);
      expect(article.description, isNull);
      expect(article.urlToImage, isNull);
    });

    test('fromJson should handle invalid date', () {
      // Arrange
      final json = {
        'source': {'name': 'Test Source'},
        'title': 'Test Title',
        'url': 'https://test.com',
        'publishedAt': 'invalid-date',
      };

      // Act
      final article = ArticleModel.fromJson(json);

      // Assert
      expect(article.publishedAt, isA<DateTime>());
    });
  });

  group('SourceModel', () {
    test('fromJson should parse source correctly', () {
      // Arrange
      final json = {
        'id': 'test-id',
        'name': 'Test Source',
      };

      // Act
      final source = SourceModel.fromJson(json);

      // Assert
      expect(source.id, 'test-id');
      expect(source.name, 'Test Source');
    });

    test('fromJson should handle null id', () {
      // Arrange
      final json = {
        'name': 'Test Source',
      };

      // Act
      final source = SourceModel.fromJson(json);

      // Assert
      expect(source.id, isNull);
      expect(source.name, 'Test Source');
    });
  });
}

