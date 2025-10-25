# API 및 데이터 관리

## REST API 설계

### 1. 기본 설정
- **Base URL**: `https://api.todaymeal.com/v1`
- **인증**: API Key 기반 인증 (헤더에 포함)
- **응답 형식**: JSON
- **에러 코드**: HTTP 상태 코드 사용

### 2. API 엔드포인트

#### 2.1 음식 검색 API
```
GET /foods/search?query={검색어}&disease={질병명}
```

**요청 파라미터**:
- `query` (string, required): 검색할 음식명
- `disease` (string, optional): 특정 질병에 대한 추천

**응답 예시**:
```json
{
  "status": "success",
  "data": [
    {
      "id": "food_001",
      "name": "연어",
      "category": "해산물",
      "nutrition": {
        "protein": 25.4,
        "fat": 13.4,
        "carbohydrate": 0.0,
        "calories": 208
      },
      "recommended_for": ["당뇨병", "심장병"],
      "avoid_for": ["통풍"],
      "description": "오메가3가 풍부한 건강한 단백질"
    }
  ],
  "total": 1
}
```

#### 2.2 영양 성분 검색 API
```
GET /nutrition/search?query={영양성분명}
```

**요청 파라미터**:
- `query` (string, required): 검색할 영양 성분명

**응답 예시**:
```json
{
  "status": "success",
  "data": [
    {
      "id": "nut_001",
      "name": "오메가3",
      "type": "지방산",
      "benefits": ["심장 건강", "뇌 기능 향상"],
      "sources": ["연어", "고등어", "견과류"],
      "daily_intake": "1-2g",
      "deficiency_symptoms": ["우울증", "피부 건조"]
    }
  ]
}
```

#### 2.3 질병별 추천 음식 API
```
GET /diseases/{질병명}/recommendations
```

**요청 파라미터**:
- `질병명` (string, required): 질병명 (URL 경로)

**응답 예시**:
```json
{
  "status": "success",
  "data": {
    "disease": "당뇨병",
    "recommended_foods": [
      {
        "id": "food_001",
        "name": "연어",
        "reason": "혈당 조절에 도움"
      }
    ],
    "avoid_foods": [
      {
        "id": "food_002",
        "name": "설탕",
        "reason": "혈당 급상승 유발"
      }
    ]
  }
}
```

## 데이터 모델

### 1. Food Entity
```dart
class Food {
  final String id;
  final String name;
  final String category;
  final Nutrition nutrition;
  final List<String> recommendedFor;
  final List<String> avoidFor;
  final String description;
  
  const Food({
    required this.id,
    required this.name,
    required this.category,
    required this.nutrition,
    required this.recommendedFor,
    required this.avoidFor,
    required this.description,
  });
}
```

### 2. Nutrition Entity
```dart
class Nutrition {
  final double protein;
  final double fat;
  final double carbohydrate;
  final double calories;
  
  const Nutrition({
    required this.protein,
    required this.fat,
    required this.carbohydrate,
    required this.calories,
  });
}
```

### 3. NutritionInfo Entity
```dart
class NutritionInfo {
  final String id;
  final String name;
  final String type;
  final List<String> benefits;
  final List<String> sources;
  final String dailyIntake;
  final List<String> deficiencySymptoms;
  
  const NutritionInfo({
    required this.id,
    required this.name,
    required this.type,
    required this.benefits,
    required this.sources,
    required this.dailyIntake,
    required this.deficiencySymptoms,
  });
}
```

## RestService 구현

### 1. 기본 RestService 클래스
```dart
class RestService {
  static const String _baseUrl = 'https://api.todaymeal.com/v1';
  static const String _apiKey = 'your_api_key_here';
  
  final Dio _dio = Dio();
  
  RestService() {
    _dio.options.baseUrl = _baseUrl;
    _dio.options.headers['Authorization'] = 'Bearer $_apiKey';
    _dio.options.headers['Content-Type'] = 'application/json';
    _dio.options.connectTimeout = 5000;
    _dio.options.receiveTimeout = 3000;
  }
  
  Future<Response> get(String path, {Map<String, dynamic>? queryParameters}) async {
    try {
      return await _dio.get(path, queryParameters: queryParameters);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }
  
  Future<Response> post(String path, {dynamic data}) async {
    try {
      return await _dio.post(path, data: data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }
  
  Exception _handleError(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
        return NetworkException('연결 시간 초과');
      case DioExceptionType.receiveTimeout:
        return NetworkException('응답 시간 초과');
      case DioExceptionType.badResponse:
        return ApiException('API 오류: ${e.response?.statusCode}');
      default:
        return NetworkException('네트워크 오류');
    }
  }
}
```

### 2. API 서비스 구현
```dart
class FoodApiService {
  final RestService _restService;
  
  FoodApiService(this._restService);
  
  Future<List<Food>> searchFoods(String query, {String? disease}) async {
    final response = await _restService.get(
      '/foods/search',
      queryParameters: {
        'query': query,
        if (disease != null) 'disease': disease,
      },
    );
    
    if (response.statusCode == 200) {
      final List<dynamic> data = response.data['data'];
      return data.map((json) => FoodModel.fromJson(json).toEntity()).toList();
    } else {
      throw ApiException('음식 검색 실패');
    }
  }
  
  Future<List<NutritionInfo>> searchNutrition(String query) async {
    final response = await _restService.get(
      '/nutrition/search',
      queryParameters: {'query': query},
    );
    
    if (response.statusCode == 200) {
      final List<dynamic> data = response.data['data'];
      return data.map((json) => NutritionInfoModel.fromJson(json).toEntity()).toList();
    } else {
      throw ApiException('영양 성분 검색 실패');
    }
  }
}
```

## SharedPreferences 서비스

### 1. 로컬 저장소 서비스
```dart
class SharedPreferencesService {
  static const String _favoriteFoodsKey = 'favorite_foods';
  static const String _searchHistoryKey = 'search_history';
  static const String _userPreferencesKey = 'user_preferences';
  
  final SharedPreferences _prefs;
  
  SharedPreferencesService(this._prefs);
  
  // 즐겨찾기 음식 저장
  Future<void> saveFavoriteFood(String foodId) async {
    final favorites = getFavoriteFoods();
    if (!favorites.contains(foodId)) {
      favorites.add(foodId);
      await _prefs.setStringList(_favoriteFoodsKey, favorites);
    }
  }
  
  // 즐겨찾기 음식 조회
  List<String> getFavoriteFoods() {
    return _prefs.getStringList(_favoriteFoodsKey) ?? [];
  }
  
  // 검색 기록 저장
  Future<void> saveSearchHistory(String query) async {
    final history = getSearchHistory();
    if (!history.contains(query)) {
      history.insert(0, query);
      if (history.length > 10) {
        history.removeLast();
      }
      await _prefs.setStringList(_searchHistoryKey, history);
    }
  }
  
  // 검색 기록 조회
  List<String> getSearchHistory() {
    return _prefs.getStringList(_searchHistoryKey) ?? [];
  }
  
  // 사용자 설정 저장
  Future<void> saveUserPreferences(Map<String, dynamic> preferences) async {
    await _prefs.setString(_userPreferencesKey, jsonEncode(preferences));
  }
  
  // 사용자 설정 조회
  Map<String, dynamic> getUserPreferences() {
    final prefsString = _prefs.getString(_userPreferencesKey);
    if (prefsString != null) {
      return jsonDecode(prefsString);
    }
    return {};
  }
}
```

## 에러 처리

### 1. 커스텀 예외 클래스
```dart
abstract class AppException implements Exception {
  final String message;
  const AppException(this.message);
}

class NetworkException extends AppException {
  const NetworkException(String message) : super(message);
}

class ApiException extends AppException {
  const ApiException(String message) : super(message);
}

class CacheException extends AppException {
  const CacheException(String message) : super(message);
}
```

### 2. 에러 핸들링
```dart
class ErrorHandler {
  static void handleError(BuildContext context, Exception e) {
    String message;
    
    if (e is NetworkException) {
      message = '네트워크 연결을 확인해주세요.';
    } else if (e is ApiException) {
      message = '서버 오류가 발생했습니다.';
    } else if (e is CacheException) {
      message = '데이터 저장 오류가 발생했습니다.';
    } else {
      message = '알 수 없는 오류가 발생했습니다.';
    }
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
}
```

## 캐싱 전략

### 1. 메모리 캐싱
```dart
class MemoryCache {
  static final Map<String, dynamic> _cache = {};
  static const Duration _cacheExpiry = Duration(minutes: 5);
  
  static void set(String key, dynamic value) {
    _cache[key] = {
      'value': value,
      'timestamp': DateTime.now(),
    };
  }
  
  static dynamic get(String key) {
    final cached = _cache[key];
    if (cached != null) {
      final timestamp = cached['timestamp'] as DateTime;
      if (DateTime.now().difference(timestamp) < _cacheExpiry) {
        return cached['value'];
      } else {
        _cache.remove(key);
      }
    }
    return null;
  }
}
```

### 2. 디스크 캐싱
```dart
class DiskCache {
  final SharedPreferencesService _prefs;
  
  DiskCache(this._prefs);
  
  Future<void> set(String key, dynamic value) async {
    final jsonString = jsonEncode(value);
    await _prefs.saveUserPreferences({key: jsonString});
  }
  
  dynamic get(String key) {
    final prefs = _prefs.getUserPreferences();
    final jsonString = prefs[key];
    if (jsonString != null) {
      return jsonDecode(jsonString);
    }
    return null;
  }
}
```
