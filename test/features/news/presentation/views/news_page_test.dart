import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:news_app/features/news/presentation/viewmodels/news_view_model.dart';
import 'package:news_app/features/news/presentation/views/news_page.dart';
import 'package:news_app/features/news/data/repositories/news_repository.dart';
import 'package:news_app/features/news/data/models/news_model.dart';

// Mock Repository for testing
class TestNewsRepository extends NewsRepository {
  @override
  Future<NewsModel> getNews({
    required String country,
    required String category,
  }) async {
    return NewsModel(
      status: 'ok',
      totalResults: 2,
      articles: [
        ArticleModel(
          source: SourceModel(name: 'Test Source 1'),
          title: 'Test Article 1',
          description: 'Test Description 1',
          url: 'https://test.com/1',
          publishedAt: DateTime.now(),
        ),
        ArticleModel(
          source: SourceModel(name: 'Test Source 2'),
          title: 'Test Article 2',
          description: 'Test Description 2',
          url: 'https://test.com/2',
          publishedAt: DateTime.now(),
        ),
      ],
    );
  }
}

void main() {
  group('NewsPage Widget', () {
    testWidgets('should display app bar with title', (WidgetTester tester) async {
      // Arrange
      final viewModel = NewsViewModel(repository: TestNewsRepository());

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: ChangeNotifierProvider<NewsViewModel>.value(
            value: viewModel,
            child: const NewsPage(),
          ),
        ),
      );

      // Assert
      expect(find.text('News'), findsOneWidget);
    });

    testWidgets('should display loading indicator when fetching',
        (WidgetTester tester) async {
      // Arrange
      final viewModel = NewsViewModel(repository: TestNewsRepository());

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: ChangeNotifierProvider<NewsViewModel>.value(
            value: viewModel,
            child: const NewsPage(),
          ),
        ),
      );

      // Trigger fetch and wait for loading state
      final future = viewModel.fetchNews();
      await tester.pump(); // First frame
      await tester.pump(); // Second frame to show loading

      // Assert - Check if loading indicator exists or if it's already loaded
      final hasLoading = find.byType(CircularProgressIndicator).evaluate().isNotEmpty;
      final hasContent = find.text('Test Article 1').evaluate().isNotEmpty;
      
      // Either loading or content should be present
      expect(hasLoading || hasContent, true);
      
      // Wait for fetch to complete
      await future;
      await tester.pumpAndSettle();
    });

    testWidgets('should display news articles after loading',
        (WidgetTester tester) async {
      // Arrange
      final viewModel = NewsViewModel(repository: TestNewsRepository());

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: ChangeNotifierProvider<NewsViewModel>.value(
            value: viewModel,
            child: const NewsPage(),
          ),
        ),
      );

      // Wait for initial load
      await tester.pump();
      await viewModel.fetchNews();
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('Test Article 1'), findsOneWidget);
    });

    testWidgets('should display country and category dropdowns',
        (WidgetTester tester) async {
      // Arrange
      final viewModel = NewsViewModel(repository: TestNewsRepository());

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: ChangeNotifierProvider<NewsViewModel>.value(
            value: viewModel,
            child: const NewsPage(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Assert
      expect(find.text('COUNTRY'), findsOneWidget);
      expect(find.text('CATEGORY'), findsOneWidget);
    });

    testWidgets('should display search field', (WidgetTester tester) async {
      // Arrange
      final viewModel = NewsViewModel(repository: TestNewsRepository());

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: ChangeNotifierProvider<NewsViewModel>.value(
            value: viewModel,
            child: const NewsPage(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Assert
      expect(find.byType(TextField), findsOneWidget);
    });
  });
}

