class NewsModel {
  final String status;
  final int totalResults;
  final List<ArticleModel> articles;

  NewsModel({
    required this.status,
    required this.totalResults,
    required this.articles,
  });

  factory NewsModel.fromJson(Map<String, dynamic> json) {
    return NewsModel(
      status: json['status'] ?? '',
      totalResults: json['totalResults'] ?? 0,
      articles: (json['articles'] as List<dynamic>?)
              ?.map((article) => ArticleModel.fromJson(article as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'totalResults': totalResults,
      'articles': articles.map((article) => article.toJson()).toList(),
    };
  }
}

class ArticleModel {
  final SourceModel source;
  final String? author;
  final String title;
  final String? description;
  final String url;
  final String? urlToImage;
  final DateTime publishedAt;
  final String? content;

  ArticleModel({
    required this.source,
    this.author,
    required this.title,
    this.description,
    required this.url,
    this.urlToImage,
    required this.publishedAt,
    this.content,
  });

  factory ArticleModel.fromJson(Map<String, dynamic> json) {
    return ArticleModel(
      source: SourceModel.fromJson(json['source'] ?? {}),
      author: json['author'],
      title: json['title'] ?? '',
      description: json['description'],
      url: json['url'] ?? '',
      urlToImage: json['urlToImage'],
      publishedAt: _parseDate(json['publishedAt']),
      content: json['content'],
    );
  }

  static DateTime _parseDate(dynamic dateString) {
    if (dateString == null) {
      return DateTime.now();
    }
    try {
      return DateTime.parse(dateString.toString());
    } catch (e) {
      return DateTime.now();
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'source': source.toJson(),
      'author': author,
      'title': title,
      'description': description,
      'url': url,
      'urlToImage': urlToImage,
      'publishedAt': publishedAt.toIso8601String(),
      'content': content,
    };
  }
}

class SourceModel {
  final String? id;
  final String name;

  SourceModel({
    this.id,
    required this.name,
  });

  factory SourceModel.fromJson(Map<String, dynamic> json) {
    return SourceModel(
      id: json['id'],
      name: json['name'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}

