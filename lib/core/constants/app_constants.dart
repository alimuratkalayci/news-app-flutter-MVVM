class AppConstants {
  // API Configuration
  // Portfolio demo note: API key is exposed intentionally to keep the project self-contained.
  // Production apps should never store API keys directly in client code.
  static const String apiKey = 'your-api-key-but-READ-THE-COMMENT-LINES-ABOVE';
  static const String baseUrl = 'https://newsapi.org/v2/top-headlines';
  
  // App Configuration
  static const String appName = 'News App';
  
  // Country Codes
  static const List<String> countries = [
    'TR',
    'AU',
    'CN',
    'US',
    'JP',
    'GB'
  ];
  
  // Categories
  static const List<String> categories = [
    'Business',
    'Entertainment',
    'General',
    'Health',
    'Science',
    'Sports',
    'Technology'
  ];
  
  // Default Values
  static const String defaultCountry = 'US';
  static const String defaultCategory = 'Business';
}

