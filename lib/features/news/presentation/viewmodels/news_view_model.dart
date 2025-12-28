import 'package:flutter/foundation.dart';
import '../../../../core/constants/app_constants.dart';
import '../../data/models/news_model.dart';
import '../../data/repositories/news_repository.dart';

enum NewsStatus {
  initial,
  loading,
  loaded,
  loadingMore,
  error,
}

class NewsViewModel extends ChangeNotifier {
  final NewsRepository _repository;
  static const int _pageSize = 3; // Her seferinde 3 haber göster

  NewsViewModel({NewsRepository? repository})
      : _repository = repository ?? NewsRepository();

  // State
  NewsStatus _status = NewsStatus.initial;
  NewsModel? _newsData;
  String? _errorMessage;
  String _selectedCountry = AppConstants.defaultCountry;
  String _selectedCategory = AppConstants.defaultCategory;
  String _searchQuery = '';
  List<ArticleModel> _filteredArticles = [];
  int _currentDisplayCount = 0; // Şu an ekranda gösterilen haber sayısı

  // Getters
  NewsStatus get status => _status;
  NewsModel? get newsData => _newsData;
  String? get errorMessage => _errorMessage;
  String get selectedCountry => _selectedCountry;
  String get selectedCategory => _selectedCategory;
  String get searchQuery => _searchQuery;

  List<ArticleModel> get articles {
    // Filtreleme yapılmışsa filtered articles'ı kullan
    final sourceList = _searchQuery.isEmpty
        ? (_newsData?.articles ?? [])
        : _filteredArticles;
    
    // Sadece gösterilecek kadarını döndür (pagination)
    return sourceList.take(_currentDisplayCount).toList();
  }

  bool get isLoading => _status == NewsStatus.loading;
  bool get isLoadingMore => _status == NewsStatus.loadingMore;
  bool get isLoaded => _status == NewsStatus.loaded;
  bool get hasError => _status == NewsStatus.error;
  bool get isEmpty => isLoaded && (articles.isEmpty);
  bool get hasMore => _hasMoreArticles(); // Daha fazla haber var mı?

  bool _hasMoreArticles() {
    final sourceList = _searchQuery.isEmpty
        ? (_newsData?.articles ?? [])
        : _filteredArticles;
    return _currentDisplayCount < sourceList.length;
  }

  // Methods
  Future<void> fetchNews({
    String? country,
    String? category,
  }) async {
    final countryToUse = country ?? _selectedCountry;
    final categoryToUse = category ?? _selectedCategory;

    _selectedCountry = countryToUse;
    _selectedCategory = categoryToUse;
    _status = NewsStatus.loading;
    _errorMessage = null;
    _currentDisplayCount = 0; // Reset display count
    notifyListeners();

    try {
      _newsData = await _repository.getNews(
        country: countryToUse,
        category: categoryToUse,
      );
      _status = NewsStatus.loaded;
      _errorMessage = null;
      
      // İlk sayfa için 3 haber göster
      _currentDisplayCount = _pageSize;
      _filterArticles(); // Apply current search filter if any
      notifyListeners();
    } catch (e) {
      _status = NewsStatus.error;
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      _newsData = null;
      _currentDisplayCount = 0;
      notifyListeners();
    }
  }

  void setCountry(String country) {
    if (_selectedCountry != country) {
      fetchNews(country: country);
    }
  }

  void setCategory(String category) {
    if (_selectedCategory != category) {
      fetchNews(category: category);
    }
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    _filterArticles();
    // Reset display count when searching
    _currentDisplayCount = _pageSize;
    notifyListeners();
  }

  void _filterArticles() {
    if (_searchQuery.isEmpty) {
      _filteredArticles = _newsData?.articles ?? [];
      return;
    }

    final query = _searchQuery.toLowerCase();
    _filteredArticles = (_newsData?.articles ?? []).where((article) {
      final titleMatch = article.title.toLowerCase().contains(query);
      final descriptionMatch = article.description
              ?.toLowerCase()
              .contains(query) ??
          false;
      final authorMatch =
          article.author?.toLowerCase().contains(query) ?? false;
      final sourceMatch = article.source.name.toLowerCase().contains(query);

      return titleMatch || descriptionMatch || authorMatch || sourceMatch;
    }).toList();
  }

  void clearSearch() {
    _searchQuery = '';
    _filterArticles();
    _currentDisplayCount = _pageSize; // Reset to first page
    notifyListeners();
  }

  Future<void> refresh() async {
    await fetchNews();
  }

  // Daha fazla haber yükle (pagination)
  Future<void> loadMore() async {
    if (!hasMore || isLoadingMore) return;

    _status = NewsStatus.loadingMore;
    notifyListeners();

    // Simüle edilmiş delay (gerçek API çağrısı yerine client-side pagination)
    await Future.delayed(const Duration(milliseconds: 300));

    // 3 haber daha ekle
    final sourceList = _searchQuery.isEmpty
        ? (_newsData?.articles ?? [])
        : _filteredArticles;
    
    _currentDisplayCount = (_currentDisplayCount + _pageSize)
        .clamp(0, sourceList.length);

    _status = NewsStatus.loaded;
    notifyListeners();
  }
}

