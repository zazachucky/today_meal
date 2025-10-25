import 'package:dartz/dartz.dart';
import '../../data/models/meal_model.dart';
import '../repositories/food_repository.dart';
import '../../core/errors/failures.dart';

/// 음식 관련 비즈니스 로직을 처리하는 UseCase
class FoodUseCase {
  final FoodRepository repository;

  FoodUseCase(this.repository);

  /// 식품 영양성분 목록 조회
  Future<Either<Failure, Meals>> getFoodList({
    String? foodName,
    int pageNo = 1,
    int numOfRows = 10,
  }) async {
    if (pageNo < 1) {
      return Left(InvalidInputFailure('페이지 번호는 1 이상이어야 합니다.'));
    }
    if (numOfRows < 1 || numOfRows > 100) {
      return Left(InvalidInputFailure('페이지 크기는 1-100 사이여야 합니다.'));
    }
    return await repository.getFoodList(
      foodName: foodName,
      pageNo: pageNo,
      numOfRows: numOfRows,
    );
  }

  /// 음식 검색
  Future<Either<Failure, Meals>> searchFoods(String query) async {
    if (query.isEmpty) {
      return Left(InvalidInputFailure('검색어는 비어있을 수 없습니다.'));
    }
    if (query.length < 2) {
      return Left(InvalidInputFailure('검색어는 2글자 이상이어야 합니다.'));
    }
    return await repository.searchFoods(query);
  }

  /// 특정 음식의 영양성분 정보 조회
  Future<Either<Failure, MealModel>> getFoodDetail(String foodName) async {
    if (foodName.isEmpty) {
      return Left(InvalidInputFailure('음식명은 비어있을 수 없습니다.'));
    }
    return await repository.getFoodDetail(foodName);
  }
}
