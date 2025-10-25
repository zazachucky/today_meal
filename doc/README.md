# Today Meal 프로젝트 문서

## 문서 목록

### 1. [프로젝트 개요](./PROJECT_OVERVIEW.md)
- 프로젝트 목표 및 개요
- 주요 기능 및 기술 스택
- 타겟 사용자 및 프로젝트 특징

### 2. [Clean Architecture 구조](./ARCHITECTURE.md)
- 폴더 구조 및 레이어별 역할
- 의존성 규칙 및 데이터 흐름
- Clean Architecture 설계 원칙

### 3. [화면 흐름도 및 UI/UX](./SCREEN_FLOW.md)
- 화면별 상세 요구사항
- 네비게이션 흐름
- 상태 관리 (Bloc) 설계
- UI/UX 가이드라인

### 4. [제약사항 및 개발 규칙](./CONSTRAINTS.md)
- 기술적 제약사항
- 아키텍처 제약사항
- 코드 리뷰 우선순위 (안전성 > 성능 > 메모리)
- 개발 규칙 및 금지사항

### 5. [API 및 데이터 관리](./API_DATA.md)
- REST API 설계 및 엔드포인트
- 데이터 모델 및 Entity 설계
- RestService 구현
- SharedPreferences 서비스
- 에러 처리 및 캐싱 전략

## 프로젝트 요약

**Today Meal**은 영양 성분 기반 건강 관리 알림 앱으로, Clean Architecture를 기반으로 설계되었습니다.

### 핵심 특징
- **Clean Architecture**: Presentation, Domain, Data 레이어 분리
- **상태 관리**: Bloc 패턴 사용
- **로컬 저장**: SharedPreferences 사용
- **API 통신**: REST API 기반
- **오프라인 지원**: 로컬 저장소 활용

### 주요 화면
1. **Splash Screen**: 1초 후 Main Screen으로 이동
2. **Main Screen**: 앱바 및 검색 버튼
3. **Search Screen**: 음식/영양 성분 검색 (API 호출 후 이동)

### 개발 우선순위
1. **안전성**: Null safety, 예외 처리, 메모리 누수 방지
2. **성능**: 위젯 최적화, 네트워크 최적화
3. **메모리**: 적절한 리소스 관리, 캐싱 전략

## 시작하기

프로젝트를 시작하기 전에 다음 문서들을 순서대로 읽어보세요:

1. [프로젝트 개요](./PROJECT_OVERVIEW.md) - 프로젝트 전체 이해
2. [Clean Architecture 구조](./ARCHITECTURE.md) - 코드 구조 이해
3. [제약사항 및 개발 규칙](./CONSTRAINTS.md) - 개발 규칙 숙지
4. [화면 흐름도 및 UI/UX](./SCREEN_FLOW.md) - 화면 설계 이해
5. [API 및 데이터 관리](./API_DATA.md) - 데이터 처리 방식 이해

## 참고사항

- 모든 코드는 Clean Architecture 원칙을 준수해야 합니다
- 안전성을 최우선으로 고려하여 개발하세요
- `assets` 폴더에만 이미지 및 리소스를 저장하세요
- 로컬 저장소만 사용하며 인증 기능은 없습니다
