import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/theme/app_theme.dart';
import 'features/news/presentation/viewmodels/news_view_model.dart';
import 'features/news/presentation/views/news_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => NewsViewModel(),
      child: MaterialApp(
        title: 'News App',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        home: const NewsPage(),
      ),
    );
  }
}
