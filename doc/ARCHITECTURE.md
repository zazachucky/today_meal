# Clean Architecture 구조 설계

## 폴더 구조

```
lib/
├── presentation/           # 프레젠테이션 레이어
│   ├── state/             # 상태 관리 (Bloc)
│   │   ├── splash/
│   │   ├── main/
│   │   └── search/
│   ├── widget/            # 재사용 가능한 위젯
│   │   ├── common/
│   │   └── custom/
│   └── screen/            # 화면별 위젯
│       ├── splash_screen.dart
│       ├── main_screen.dart
│       └── search_screen.dart
├── domain/                # 도메인 레이어
│   ├── entities/          # 비즈니스 엔티티
│   │   ├── food.dart
│   │   ├── nutrition.dart
│   │   └── disease.dart
│   ├── repositories/      # 리포지토리 인터페이스
│   │   ├── food_repository.dart
│   │   └── nutrition_repository.dart
│   └── usecases/          # 비즈니스 로직
│       ├── get_food_recommendations.dart
│       └── search_nutrition_info.dart
├── data/                  # 데이터 레이어
│   ├── datasources/       # 데이터 소스
│   │   ├── local/
│   │   │   └── shared_preferences_service.dart
│   │   └── remote/
│   │       └── rest_service.dart
│   ├── models/            # 데이터 모델
│   │   ├── food_model.dart
│   │   └── nutrition_model.dart
│   └── repositories/      # 리포지토리 구현
│       ├── food_repository_impl.dart
│       └── nutrition_repository_impl.dart
└── core/                  # 공통 기능
    ├── constants/
    ├── errors/
    ├── network/
    └── utils/
```

## 레이어별 역할

### 1. Presentation Layer (프레젠테이션 레이어)
- **목적**: 사용자 인터페이스와 사용자 상호작용 처리
- **구성요소**:
  - `state/`: Bloc을 통한 상태 관리
  - `widget/`: 재사용 가능한 UI 컴포넌트
  - `screen/`: 각 화면별 위젯

### 2. Domain Layer (도메인 레이어)
- **목적**: 비즈니스 로직과 핵심 규칙 정의
- **구성요소**:
  - `entities/`: 비즈니스 엔티티 (순수 Dart 클래스)
  - `repositories/`: 데이터 접근 인터페이스
  - `usecases/`: 특정 비즈니스 로직 실행

### 3. Data Layer (데이터 레이어)
- **목적**: 데이터 저장 및 외부 API 통신
- **구성요소**:
  - `datasources/`: 로컬/원격 데이터 소스
  - `models/`: JSON 직렬화/역직렬화 모델
  - `repositories/`: 도메인 리포지토리 구현

### 4. Core Layer (코어 레이어)
- **목적**: 공통 기능과 유틸리티 제공
- **구성요소**:
  - `constants/`: 앱 전반 상수
  - `errors/`: 에러 처리
  - `network/`: 네트워크 관련 유틸리티
  - `utils/`: 공통 유틸리티 함수

## 의존성 규칙

```
Presentation → Domain ← Data
     ↓           ↑
    Core ←────────┘
```

- **외부 레이어는 내부 레이어에 의존할 수 있음**
- **내부 레이어는 외부 레이어에 의존할 수 없음**
- **Domain Layer는 다른 레이어에 의존하지 않음**

## 데이터 흐름

1. **사용자 액션** → Presentation Layer
2. **UseCase 호출** → Domain Layer
3. **Repository 호출** → Data Layer
4. **데이터 반환** → Domain Layer → Presentation Layer
5. **UI 업데이트** → Presentation Layer
