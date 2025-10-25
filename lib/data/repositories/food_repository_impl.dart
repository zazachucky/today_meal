import 'package:dartz/dartz.dart';
import '../datasources/remote/rest_service.dart';
import '../models/meal_model.dart';
import '../../domain/repositories/food_repository.dart';
import '../../core/errors/failures.dart';

/// 음식 리포지토리 구현체
class FoodRepositoryImpl implements FoodRepository {
  final RestService _restService;

  FoodRepositoryImpl(this._restService);

  @override
  Future<Either<Failure, Meals>> getFoodList({
    String? foodName,
    int pageNo = 1,
    int numOfRows = 10,
  }) async {
    try {
      final meals = await _restService.getFoodList(
        foodName: foodName,
        pageNo: pageNo,
        numOfRows: numOfRows,
      );
      return Right(meals);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Meals>> searchFoods(String query) async {
    try {
      final meals = await _restService.searchFood(query);
      return Right(meals);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, MealModel>> getFoodDetail(String foodName) async {
    try {
      final meals = await _restService.searchFood(foodName);
      if (meals.meals.isNotEmpty) {
        return Right(meals.meals.first);
      } else {
        return Left(NotFoundFailure('음식을 찾을 수 없습니다: $foodName'));
      }
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
