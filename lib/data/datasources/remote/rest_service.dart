import 'package:dio/dio.dart';
import 'meal_api_service.dart';
import '../../models/meal_model.dart';

/// REST API 서비스 (API 서비스의 래퍼)
class RestService {
  final MealApiService _mealApiService;

  RestService(this._mealApiService);

  /// 식품 목록 조회
  Future<Meals> getFoodList({
    String? foodName,
    int pageNo = 1,
    int numOfRows = 10,
  }) async {
    return await _mealApiService.getFoodList(
      foodName: foodName,
      pageNo: pageNo,
      numOfRows: numOfRows,
    );
  }

  /// 음식 검색
  Future<Meals> searchFood(String foodName) async {
    return await _mealApiService.searchFood(foodName);
  }
}
