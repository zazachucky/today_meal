# 제약사항 및 개발 규칙

## 기술적 제약사항

### 1. 데이터 저장소
- **로컬 저장만 사용**: `SharedPreferences`를 통한 로컬 데이터 저장
- **인증 없음**: 사용자 로그인/회원가입 기능 없음
- **오프라인 지원**: 네트워크 연결 없이도 기본 기능 사용 가능

### 2. 이미지 및 리소스
- **이미지 접근**: `assets` 폴더에만 접근 가능
- **리소스 관리**: 모든 이미지, 아이콘, 폰트는 `assets` 폴더 내에 위치
- **이미지 최적화**: 앱 크기 최적화를 위한 이미지 압축 권장

### 3. 네트워크 통신
- **REST API만 사용**: GraphQL, WebSocket 등 다른 통신 방식 사용 금지
- **HTTP/HTTPS**: 안전한 통신을 위한 HTTPS 사용 권장
- **타임아웃 설정**: 네트워크 요청에 적절한 타임아웃 설정

## 아키텍처 제약사항

### 1. Clean Architecture 준수
- **의존성 규칙**: 외부 레이어는 내부 레이어에만 의존
- **레이어 분리**: Presentation, Domain, Data 레이어 명확히 분리
- **인터페이스 사용**: Repository는 인터페이스로 정의하고 구현체에서 구현

### 2. 상태 관리
- **Bloc 패턴 사용**: Provider, Riverpod 등 다른 상태 관리 라이브러리 사용 금지
- **단방향 데이터 흐름**: Event → State 흐름만 허용
- **불변성**: State 객체는 불변(immutable)으로 유지

### 3. 코드 구조
- **파일 명명 규칙**: snake_case 사용
- **클래스 명명 규칙**: PascalCase 사용
- **상수 명명 규칙**: UPPER_SNAKE_CASE 사용

## 코드 리뷰 우선순위

### 1. 안전성 (Safety) - 최우선
- **Null Safety**: null 체크 및 null safety 준수
- **예외 처리**: try-catch 블록을 통한 적절한 예외 처리
- **입력 검증**: 사용자 입력에 대한 유효성 검사
- **메모리 누수**: dispose 메서드 구현 및 리소스 해제

```dart
// 좋은 예
class MyWidget extends StatefulWidget {
  @override
  _MyWidgetState createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  late StreamSubscription _subscription;
  
  @override
  void initState() {
    super.initState();
    _subscription = stream.listen((data) {
      // 처리 로직
    });
  }
  
  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
```

### 2. 성능 (Performance) - 두 번째 우선순위
- **위젯 최적화**: 불필요한 rebuild 방지
- **메모리 사용량**: 적절한 메모리 사용
- **네트워크 최적화**: 불필요한 API 호출 방지
- **이미지 최적화**: 적절한 이미지 크기 및 캐싱

```dart
// 좋은 예 - const 생성자 사용
class MyWidget extends StatelessWidget {
  const MyWidget({Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return const Text('Hello World');
  }
}

// 좋은 예 - ListView.builder 사용
ListView.builder(
  itemCount: items.length,
  itemBuilder: (context, index) {
    return ListTile(title: Text(items[index]));
  },
)
```

### 3. 메모리 (Memory) - 세 번째 우선순위
- **메모리 누수 방지**: 적절한 리소스 해제
- **캐싱 전략**: 적절한 캐싱으로 메모리 효율성 향상
- **이미지 메모리**: 이미지 로딩 시 메모리 사용량 고려

```dart
// 좋은 예 - 이미지 캐싱
CachedNetworkImage(
  imageUrl: imageUrl,
  placeholder: (context, url) => CircularProgressIndicator(),
  errorWidget: (context, url, error) => Icon(Icons.error),
)
```

## 개발 규칙

### 1. 코딩 스타일
- **Dart 스타일 가이드**: 공식 Dart 스타일 가이드 준수
- **주석 작성**: 복잡한 로직에 대한 주석 작성
- **함수 길이**: 함수는 50줄 이내로 유지
- **클래스 길이**: 클래스는 200줄 이내로 유지

### 2. 에러 처리
- **예외 처리**: 모든 외부 호출에 대한 예외 처리
- **에러 로깅**: 적절한 에러 로깅 및 사용자 피드백
- **Fallback UI**: 에러 발생 시 대체 UI 제공

```dart
// 좋은 예
try {
  final result = await apiCall();
  return result;
} catch (e) {
  logger.error('API 호출 실패: $e');
  throw ApiException('API 호출에 실패했습니다.');
}
```

### 3. 테스트
- **단위 테스트**: 핵심 비즈니스 로직에 대한 단위 테스트
- **위젯 테스트**: 주요 위젯에 대한 위젯 테스트
- **통합 테스트**: 주요 사용자 플로우에 대한 통합 테스트

### 4. 문서화
- **API 문서**: 모든 public API에 대한 문서 작성
- **README**: 프로젝트 설정 및 실행 방법 문서화
- **주석**: 복잡한 알고리즘에 대한 주석 작성

## 금지사항

### 1. 아키텍처 위반
- **직접 의존성**: 레이어 간 직접 의존성 생성 금지
- **비즈니스 로직**: Presentation 레이어에 비즈니스 로직 작성 금지
- **데이터 접근**: Domain 레이어에서 직접 데이터 접근 금지

### 2. 성능 저하 요소
- **무한 루프**: 무한 루프나 재귀 호출 금지
- **메모리 누수**: dispose 하지 않는 리소스 사용 금지
- **불필요한 rebuild**: setState 남용 금지

### 3. 보안 위험
- **하드코딩**: API 키나 민감한 정보 하드코딩 금지
- **입력 검증**: 사용자 입력에 대한 검증 없이 처리 금지
- **로깅**: 민감한 정보 로깅 금지
