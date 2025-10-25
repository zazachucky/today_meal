import 'package:dartz/dartz.dart';
import '../entities/foodinfo.dart';
import '../repositories/food_repository.dart';
import '../../core/errors/failures.dart';

/// 음식 관련 비즈니스 로직을 처리하는 UseCase
class FoodUseCase {
  final FoodRepository repository;

  FoodUseCase(this.repository);

  /// 모든 음식 목록 조회
  Future<Either<Failure, List<FoodInfo>>> getAllFoods() async {
    return await repository.getAllFoods();
  }

  /// 카테고리별 음식 목록 조회
  Future<Either<Failure, List<FoodInfo>>> getFoodsByCategory(
      String category) async {
    if (category.isEmpty) {
      return Left(InvalidInputFailure('카테고리는 비어있을 수 없습니다.'));
    }
    return await repository.getFoodsByCategory(category);
  }

  /// 음식 검색
  Future<Either<Failure, List<FoodInfo>>> searchFoods(String query) async {
    if (query.isEmpty) {
      return Left(InvalidInputFailure('검색어는 비어있을 수 없습니다.'));
    }
    return await repository.searchFoods(query);
  }

  /// 특정 음식 상세 정보 조회
  Future<Either<Failure, FoodInfo>> getFoodById(String id) async {
    if (id.isEmpty) {
      return Left(InvalidInputFailure('음식 ID는 비어있을 수 없습니다.'));
    }
    return await repository.getFoodById(id);
  }

  /// 인기 음식 목록 조회
  Future<Either<Failure, List<FoodInfo>>> getPopularFoods() async {
    return await repository.getPopularFoods();
  }

  /// 추천 음식 목록 조회
  Future<Either<Failure, List<FoodInfo>>> getRecommendedFoods() async {
    return await repository.getRecommendedFoods();
  }
}
