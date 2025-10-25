import 'package:flutter/material.dart';
import 'core/di/service_locator.dart';
import 'domain/usecases/food_usecase.dart';
import 'data/models/meal_model.dart';

/// API 사용 예시
class ApiUsageExample {
  final FoodUseCase _foodUseCase = sl<FoodUseCase>();

  /// 음식 검색 예시
  Future<void> searchFoodExample() async {
    try {
      final result = await _foodUseCase.searchFoods('김치');

      result.fold(
        (failure) {
          print('검색 실패: ${failure.message}');
        },
        (meals) {
          print('검색 결과: ${meals.meals.length}개');
          for (var meal in meals.meals) {
            print('음식명: ${meal.name}');
            print('칼로리: ${meal.kcal} kcal');
            print('단백질: ${meal.protein} g');
            print('---');
          }
        },
      );
    } catch (e) {
      print('오류 발생: $e');
    }
  }

  /// 음식 목록 조회 예시
  Future<void> getFoodListExample() async {
    try {
      final result = await _foodUseCase.getFoodList(
        pageNo: 1,
        numOfRows: 5,
      );

      result.fold(
        (failure) {
          print('목록 조회 실패: ${failure.message}');
        },
        (meals) {
          print('총 ${meals.totalCount}개의 음식 중 ${meals.meals.length}개 조회');
          print('현재 페이지: ${meals.pageNo}/${meals.maxPage}');
        },
      );
    } catch (e) {
      print('오류 발생: $e');
    }
  }

  /// 특정 음식 상세 정보 조회 예시
  Future<void> getFoodDetailExample() async {
    try {
      final result = await _foodUseCase.getFoodDetail('된장찌개');

      result.fold(
        (failure) {
          print('상세 정보 조회 실패: ${failure.message}');
        },
        (meal) {
          print('음식명: ${meal.name}');
          print('칼로리: ${meal.kcal} kcal');
          print('단백질: ${meal.protein} g');
          print('지방: ${meal.fat} g');
          print('탄수화물: ${meal.carbohydrate} g');
          print('당분: ${meal.sugar} g');
          print('나트륨: ${meal.sodium} mg');
        },
      );
    } catch (e) {
      print('오류 발생: $e');
    }
  }
}
