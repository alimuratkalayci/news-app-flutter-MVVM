import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:news_app/features/news/data/models/news_model.dart';
import 'package:news_app/features/news/presentation/widgets/news_card.dart';

void main() {
  group('NewsCard Widget', () {
    testWidgets('should display article title', (WidgetTester tester) async {
      // Arrange
      final article = ArticleModel(
        source: SourceModel(name: 'Test Source'),
        title: 'Test Article Title',
        url: 'https://test.com',
        publishedAt: DateTime.now(),
      );

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: NewsCard(article: article),
          ),
        ),
      );

      // Assert
      expect(find.text('Test Article Title'), findsOneWidget);
    });

    testWidgets('should display source name', (WidgetTester tester) async {
      // Arrange
      final article = ArticleModel(
        source: SourceModel(name: 'Test Source'),
        title: 'Test Title',
        url: 'https://test.com',
        publishedAt: DateTime.now(),
      );

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: NewsCard(article: article),
          ),
        ),
      );

      // Assert
      expect(find.textContaining('Test Source'), findsWidgets);
    });

    testWidgets('should display description when available',
        (WidgetTester tester) async {
      // Arrange
      final article = ArticleModel(
        source: SourceModel(name: 'Test Source'),
        title: 'Test Title',
        description: 'Test Description',
        url: 'https://test.com',
        publishedAt: DateTime.now(),
      );

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: NewsCard(article: article),
          ),
        ),
      );

      // Assert
      expect(find.text('Test Description'), findsOneWidget);
    });

    testWidgets('should display author when available',
        (WidgetTester tester) async {
      // Arrange
      final article = ArticleModel(
        source: SourceModel(name: 'Test Source'),
        title: 'Test Title',
        author: 'Test Author',
        url: 'https://test.com',
        publishedAt: DateTime.now(),
      );

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: NewsCard(article: article),
          ),
        ),
      );

      // Assert
      expect(find.text('Test Author'), findsOneWidget);
    });

    testWidgets('should call onTap when tapped', (WidgetTester tester) async {
      // Arrange
      bool tapped = false;
      final article = ArticleModel(
        source: SourceModel(name: 'Test Source'),
        title: 'Test Title',
        url: 'https://test.com',
        publishedAt: DateTime.now(),
      );

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: NewsCard(
              article: article,
              onTap: () {
                tapped = true;
              },
            ),
          ),
        ),
      );

      await tester.tap(find.byType(NewsCard));
      await tester.pump();

      // Assert
      expect(tapped, true);
    });
  });
}

