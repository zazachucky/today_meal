import 'package:dartz/dartz.dart';
import '../entities/foodinfo.dart';
import '../../core/errors/failures.dart';

/// 음식 데이터 접근을 위한 리포지토리 인터페이스
abstract class FoodRepository {
  /// 모든 음식 목록 조회
  Future<Either<Failure, List<FoodInfo>>> getAllFoods();

  /// 카테고리별 음식 목록 조회
  Future<Either<Failure, List<FoodInfo>>> getFoodsByCategory(String category);

  /// 음식 검색
  Future<Either<Failure, List<FoodInfo>>> searchFoods(String query);

  /// 특정 음식 상세 정보 조회
  Future<Either<Failure, FoodInfo>> getFoodById(String id);

  /// 인기 음식 목록 조회
  Future<Either<Failure, List<FoodInfo>>> getPopularFoods();

  /// 추천 음식 목록 조회
  Future<Either<Failure, List<FoodInfo>>> getRecommendedFoods();
}
