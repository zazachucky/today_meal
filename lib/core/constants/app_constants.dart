/// 앱 전반에서 사용되는 상수들
class AppConstants {
  // API 관련
  static const String baseUrl = 'https://api.todaymeal.com';
  static const String apiVersion = 'v1';
  static const Duration connectTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);

  // 로컬 저장소 키
  static const String userPreferencesKey = 'user_preferences';
  static const String favoriteFoodsKey = 'favorite_foods';
  static const String searchHistoryKey = 'search_history';

  // UI 관련
  static const double defaultPadding = 16.0;
  static const double smallPadding = 8.0;
  static const double largePadding = 24.0;
  static const double borderRadius = 12.0;

  // 애니메이션 지속 시간
  static const Duration shortAnimation = Duration(milliseconds: 200);
  static const Duration mediumAnimation = Duration(milliseconds: 300);
  static const Duration longAnimation = Duration(milliseconds: 500);

  // 페이지네이션
  static const int defaultPageSize = 20;
  static const int maxPageSize = 100;

  // 이미지 관련
  static const String defaultImageUrl = 'https://via.placeholder.com/300x200';
  static const int maxImageSize = 5 * 1024 * 1024; // 5MB

  // 검색 관련
  static const int maxSearchHistory = 10;
  static const int minSearchLength = 2;
}
