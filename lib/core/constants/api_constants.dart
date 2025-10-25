import 'package:flutter_dotenv/flutter_dotenv.dart';

/// API 관련 상수들
class ApiConstants {
  // API 기본 URL (식품영양성분 데이터 API)
  static String get baseUrl =>
      dotenv.env['API_BASE_URL'] ??
      'https://apis.data.go.kr/1471000/FoodNtrIrdntInfoService1';

  // API 키 (환경변수에서 가져옴)
  static String get apiKey => dotenv.env['API_KEY'] ?? 'YOUR_API_KEY_HERE';

  // 엔드포인트
  static const String getFoodList = '/getFoodNtrItdntList1';

  // 요청 파라미터
  static const String serviceKey = 'serviceKey';
  static const String pageNo = 'pageNo';
  static const String numOfRows = 'numOfRows';
  static const String type = 'type';
  static const String descKor = 'desc_kor';

  // 기본값
  static const int defaultPageNo = 1;
  static const int defaultNumOfRows = 10;
  static const String defaultType = 'json';

  // 타임아웃 설정
  static const Duration connectTimeout = Duration(seconds: 10);
  static const Duration receiveTimeout = Duration(seconds: 10);
}
