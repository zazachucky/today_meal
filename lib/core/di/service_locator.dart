import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';
import '../../data/datasources/remote/meal_api_service.dart';
import '../../data/datasources/remote/rest_service.dart';
import '../../data/repositories/food_repository_impl.dart';
import '../../domain/repositories/food_repository.dart';
import '../../domain/usecases/food_usecase.dart';
import '../constants/api_constants.dart';

/// 서비스 로케이터 (의존성 주입)
final GetIt sl = GetIt.instance;

/// 의존성 주입 초기화
Future<void> init() async {
  // External dependencies
  sl.registerLazySingleton<Dio>(() => Dio());

  // Data sources
  sl.registerLazySingleton<MealApiService>(
    () => MealApiService(),
  );

  sl.registerLazySingleton<RestService>(
    () => RestService(sl()),
  );

  // Repository
  sl.registerLazySingleton<FoodRepository>(
    () => FoodRepositoryImpl(sl()),
  );

  // Use cases
  sl.registerLazySingleton<FoodUseCase>(
    () => FoodUseCase(sl()),
  );
}
