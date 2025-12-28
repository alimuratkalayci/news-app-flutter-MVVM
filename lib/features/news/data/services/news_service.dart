import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../../core/constants/app_constants.dart';
import '../models/news_model.dart';

class NewsService {
  Future<NewsModel> fetchNews({
    required String country,
    required String category,
  }) async {
    try {
      final uri = Uri.parse(
        '${AppConstants.baseUrl}?country=$country&category=$category&apiKey=${AppConstants.apiKey}',
      );

      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body) as Map<String, dynamic>;
        return NewsModel.fromJson(jsonData);
      } else {
        throw Exception(
          'Failed to load news: ${response.statusCode} - ${response.reasonPhrase}',
        );
      }
    } catch (e) {
      throw Exception('Error fetching news: $e');
    }
  }
}

