import 'package:dio/dio.dart';
import '../../models/meal_model.dart';
import '../../../core/constants/api_constants.dart';

/// 식품 영양성분 데이터 API 서비스
class MealApiService {
  late final Dio _dio;

  MealApiService() {
    _dio = Dio(BaseOptions(
      baseUrl: ApiConstants.baseUrl,
      connectTimeout: ApiConstants.connectTimeout,
      receiveTimeout: ApiConstants.receiveTimeout,
      headers: {
        'Content-Type': 'application/json',
      },
    ));

    // 로깅 인터셉터 추가 (개발시에만)
    _dio.interceptors.add(LogInterceptor(
      requestBody: true,
      responseBody: true,
      logPrint: (obj) => print(obj),
    ));
  }

  /// 식품 영양성분 정보를 조회합니다.
  ///
  /// [foodName] 검색할 음식명 (선택사항)
  /// [pageNo] 페이지 번호 (기본값: 1)
  /// [numOfRows] 한 페이지당 행 수 (기본값: 10)
  Future<Meals> getFoodList({
    String? foodName,
    int pageNo = ApiConstants.defaultPageNo,
    int numOfRows = ApiConstants.defaultNumOfRows,
  }) async {
    try {
      final queryParameters = {
        ApiConstants.serviceKey: ApiConstants.apiKey,
        ApiConstants.pageNo: pageNo.toString(),
        ApiConstants.numOfRows: numOfRows.toString(),
        ApiConstants.type: ApiConstants.defaultType,
      };

      // 음식명이 제공된 경우 검색 파라미터 추가
      if (foodName != null && foodName.isNotEmpty) {
        queryParameters[ApiConstants.descKor] = foodName;
      }

      final response = await _dio.get(
        ApiConstants.getFoodList,
        queryParameters: queryParameters,
      );

      if (response.statusCode == 200) {
        return Meals.fromJson(response.data);
      } else {
        throw Exception('API 호출 실패: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw Exception('예상치 못한 오류가 발생했습니다: $e');
    }
  }

  /// 특정 음식의 영양성분 정보를 검색합니다.
  Future<Meals> searchFood(String foodName) async {
    return getFoodList(foodName: foodName);
  }

  /// DioException을 처리하여 사용자 친화적인 에러 메시지를 반환합니다.
  Exception _handleDioException(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return Exception('네트워크 연결 시간이 초과되었습니다. 다시 시도해주세요.');

      case DioExceptionType.badResponse:
        final statusCode = e.response?.statusCode;
        if (statusCode == 404) {
          return Exception('요청한 데이터를 찾을 수 없습니다.');
        } else if (statusCode == 500) {
          return Exception('서버 오류가 발생했습니다. 잠시 후 다시 시도해주세요.');
        } else {
          return Exception('API 호출 실패: $statusCode');
        }

      case DioExceptionType.cancel:
        return Exception('요청이 취소되었습니다.');

      case DioExceptionType.connectionError:
        return Exception('네트워크 연결을 확인해주세요.');

      case DioExceptionType.badCertificate:
        return Exception('인증서 오류가 발생했습니다.');

      case DioExceptionType.unknown:
      default:
        return Exception('네트워크 오류가 발생했습니다: ${e.message}');
    }
  }
}
