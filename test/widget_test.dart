import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:news_app/main.dart';
import 'package:news_app/features/news/presentation/viewmodels/news_view_model.dart';
import 'package:news_app/features/news/data/repositories/news_repository.dart';
import 'package:news_app/features/news/data/models/news_model.dart';

// Mock Repository for main app test
class MockNewsRepository extends NewsRepository {
  @override
  Future<NewsModel> getNews({
    required String country,
    required String category,
  }) async {
    return NewsModel(
      status: 'ok',
      totalResults: 0,
      articles: [],
    );
  }
}

void main() {
  testWidgets('App should start without errors', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Verify that the app starts
    expect(find.byType(MaterialApp), findsOneWidget);
  });

  testWidgets('App should display News page', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Verify that News page is displayed
    expect(find.text('News'), findsOneWidget);
  });

  testWidgets('App should have Provider setup', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Verify that Provider is set up
    final context = tester.element(find.byType(MaterialApp));
    expect(Provider.of<NewsViewModel>(context, listen: false), isNotNull);
  });
}
