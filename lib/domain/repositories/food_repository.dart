import 'package:dartz/dartz.dart';
import '../../data/models/meal_model.dart';
import '../../core/errors/failures.dart';

/// 음식 데이터 접근을 위한 리포지토리 인터페이스
abstract class FoodRepository {
  /// 식품 영양성분 목록 조회
  Future<Either<Failure, Meals>> getFoodList({
    String? foodName,
    int pageNo,
    int numOfRows,
  });

  /// 음식 검색
  Future<Either<Failure, Meals>> searchFoods(String query);

  /// 특정 음식의 영양성분 정보 조회
  Future<Either<Failure, MealModel>> getFoodDetail(String foodName);
}
