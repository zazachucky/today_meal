import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

/// 영양소 데이터 모델
class NutritionData {
  final String date;
  final double calories;
  final double protein;
  final double carbs;
  final double fat;
  final double fiber;
  final double sugar;
  final double sodium;
  final double vitaminC;
  final double calcium;
  final double iron;

  NutritionData({
    required this.date,
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fat,
    required this.fiber,
    required this.sugar,
    required this.sodium,
    required this.vitaminC,
    required this.calcium,
    required this.iron,
  });

  Map<String, dynamic> toJson() {
    return {
      'date': date,
      'calories': calories,
      'protein': protein,
      'carbs': carbs,
      'fat': fat,
      'fiber': fiber,
      'sugar': sugar,
      'sodium': sodium,
      'vitaminC': vitaminC,
      'calcium': calcium,
      'iron': iron,
    };
  }

  factory NutritionData.fromJson(Map<String, dynamic> json) {
    return NutritionData(
      date: json['date'],
      calories: (json['calories'] ?? 0).toDouble(),
      protein: (json['protein'] ?? 0).toDouble(),
      carbs: (json['carbs'] ?? 0).toDouble(),
      fat: (json['fat'] ?? 0).toDouble(),
      fiber: (json['fiber'] ?? 0).toDouble(),
      sugar: (json['sugar'] ?? 0).toDouble(),
      sodium: (json['sodium'] ?? 0).toDouble(),
      vitaminC: (json['vitaminC'] ?? 0).toDouble(),
      calcium: (json['calcium'] ?? 0).toDouble(),
      iron: (json['iron'] ?? 0).toDouble(),
    );
  }
}

/// 영양소 데이터 관리 서비스
class NutritionDataService {
  static const String _nutritionDataKey = 'nutrition_data';

  /// 오늘의 영양소 데이터 저장
  static Future<void> saveTodayNutrition(NutritionData data) async {
    final prefs = await SharedPreferences.getInstance();
    final nutritionDataList = await getNutritionDataList();

    // 같은 날짜의 데이터가 있으면 업데이트, 없으면 추가
    final existingIndex =
        nutritionDataList.indexWhere((item) => item.date == data.date);

    if (existingIndex != -1) {
      nutritionDataList[existingIndex] = data;
    } else {
      nutritionDataList.add(data);
    }

    // 최근 30일 데이터만 유지
    nutritionDataList.sort((a, b) => b.date.compareTo(a.date));
    final recentData = nutritionDataList.take(30).toList();

    final jsonList = recentData.map((data) => data.toJson()).toList();
    await prefs.setString(_nutritionDataKey, jsonEncode(jsonList));
  }

  /// 영양소 데이터 목록 조회
  static Future<List<NutritionData>> getNutritionDataList() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_nutritionDataKey);

    if (jsonString == null) {
      // 테스트용 기본 데이터 생성
      await _initializeTestData();
      return await getNutritionDataList();
    }

    final jsonList = jsonDecode(jsonString) as List;
    return jsonList.map((json) => NutritionData.fromJson(json)).toList();
  }

  /// 오늘의 영양소 데이터 조회
  static Future<NutritionData?> getTodayNutrition() async {
    final today = DateTime.now().toIso8601String().split('T')[0];
    final nutritionDataList = await getNutritionDataList();

    try {
      return nutritionDataList.firstWhere((data) => data.date == today);
    } catch (e) {
      return null;
    }
  }

  /// 특정 날짜의 영양소 데이터 조회
  static Future<NutritionData?> getNutritionByDate(String date) async {
    final nutritionDataList = await getNutritionDataList();

    try {
      return nutritionDataList.firstWhere((data) => data.date == date);
    } catch (e) {
      return null;
    }
  }

  /// 테스트용 기본 데이터 초기화
  static Future<void> _initializeTestData() async {
    final today = DateTime.now().toIso8601String().split('T')[0];
    final yesterday = DateTime.now()
        .subtract(const Duration(days: 1))
        .toIso8601String()
        .split('T')[0];
    final dayBeforeYesterday = DateTime.now()
        .subtract(const Duration(days: 2))
        .toIso8601String()
        .split('T')[0];

    final testData = [
      NutritionData(
        date: today,
        calories: 1850.0,
        protein: 65.0,
        carbs: 220.0,
        fat: 75.0,
        fiber: 25.0,
        sugar: 45.0,
        sodium: 2300.0,
        vitaminC: 85.0,
        calcium: 1200.0,
        iron: 18.0,
      ),
      NutritionData(
        date: yesterday,
        calories: 2100.0,
        protein: 80.0,
        carbs: 250.0,
        fat: 85.0,
        fiber: 30.0,
        sugar: 50.0,
        sodium: 2500.0,
        vitaminC: 95.0,
        calcium: 1100.0,
        iron: 20.0,
      ),
      NutritionData(
        date: dayBeforeYesterday,
        calories: 1750.0,
        protein: 60.0,
        carbs: 200.0,
        fat: 70.0,
        fiber: 22.0,
        sugar: 40.0,
        sodium: 2200.0,
        vitaminC: 75.0,
        calcium: 1000.0,
        iron: 16.0,
      ),
    ];

    final jsonList = testData.map((data) => data.toJson()).toList();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_nutritionDataKey, jsonEncode(jsonList));
  }
}
