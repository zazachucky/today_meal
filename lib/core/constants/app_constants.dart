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

  // 한국인 성인 일일 영양소 권장량 (2020 한국인 영양소 섭취기준)
  static const Map<String, double> dailyNutritionTargets = {
    'calories': 2000.0, // 칼로리 (kcal) - 성인 남성 기준
    'protein': 65.0, // 단백질 (g) - 성인 남성 기준
    'carbs': 300.0, // 탄수화물 (g) - 총 에너지의 55-65%
    'fat': 60.0, // 지방 (g) - 총 에너지의 15-30%
    'fiber': 25.0, // 식이섬유 (g) - 성인 기준
    'sugar': 50.0, // 당분 (g) - 총 에너지의 10% 이하
  };

  // 영양소 위험 임계값 (권장량 대비 비율)
  static const Map<String, double> nutritionRiskThresholds = {
    'protein_low': 0.5, // 단백질 부족 (50% 미만)
    'protein_high': 2.0, // 단백질 과다 (200% 초과)
    'carbs_low': 0.4, // 탄수화물 부족 (40% 미만)
    'carbs_high': 1.5, // 탄수화물 과다 (150% 초과)
    'fat_low': 0.3, // 지방 부족 (30% 미만)
    'fat_high': 1.5, // 지방 과다 (150% 초과)
    'fiber_low': 0.5, // 식이섬유 부족 (50% 미만)
    'sugar_high': 1.0, // 당분 과다 (100% 초과)
  };
}
