import '../models/news_model.dart';
import '../services/news_service.dart';

class NewsRepository {
  final NewsService _newsService;

  NewsRepository({NewsService? newsService})
      : _newsService = newsService ?? NewsService();

  Future<NewsModel> getNews({
    required String country,
    required String category,
  }) async {
    try {
      return await _newsService.fetchNews(
        country: country,
        category: category,
      );
    } catch (e) {
      rethrow;
    }
  }
}

