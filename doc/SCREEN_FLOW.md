# 화면 흐름도 및 UI/UX 요구사항

## 화면 흐름도

```
앱 시작
    ↓
Splash Screen (1초)
    ↓
Main Screen
    ↓
검색 버튼 클릭
    ↓
API 호출 (로딩 표시)
    ↓
Search Screen
```

## 화면별 상세 요구사항

### 1. Splash Screen
**목적**: 앱 로딩 및 브랜딩

**요구사항**:
- 앱 아이콘 또는 로고 표시
- 노출 시간: 1초 후 자동으로 Main Screen으로 이동
- 로딩 인디케이터 표시 (선택사항)

**구현 요소**:
- `SplashScreen` 위젯
- `Timer`를 통한 자동 화면 전환
- `Navigator.pushReplacement()` 사용

### 2. Main Screen
**목적**: 앱의 메인 화면 및 기능 접근점
구성요소:
추천 음식 이미지 스크롤
음식 검색창
오늘의 영양소 섭취량 입력

**요구사항**:
- **AppBar**: 앱 제목 및 기본 네비게이션
- **검색 버튼**: Search Screen으로 이동하는 버튼
- **기능 카드들**: 주요 기능에 대한 접근점 제공
- **하단 네비게이션** (선택사항)

**UI 구성요소**:
```
┌─────────────────────────┐
│      AppBar             │
├─────────────────────────┤
│                         │
│    [검색 버튼]           │
│                         │
│  [기능 카드 1]           │
│  [기능 카드 2]           │
│  [기능 카드 3]           │
│                         │
└─────────────────────────┘
```

**구현 요소**:
- `MainScreen` 위젯
- `AppBar` 위젯
- 검색 버튼 (`ElevatedButton` 또는 `FloatingActionButton`)
- 기능 카드들 (`Card` 위젯)

### 3. Search Screen
**목적**: 음식 및 영양 성분 검색 기능

**요구사항**:
- **검색 입력창**: 사용자가 검색어를 입력할 수 있는 텍스트 필드
- **검색 결과 리스트**: 검색된 음식/영양 성분 목록 표시
- **로딩 상태**: API 호출 중 로딩 인디케이터 표시
- **에러 처리**: 검색 실패 시 에러 메시지 표시

**UI 구성요소**:
```
┌─────────────────────────┐
│      AppBar             │
├─────────────────────────┤
│  [검색 입력창]           │
├─────────────────────────┤
│                         │
│  [검색 결과 1]           │
│  [검색 결과 2]           │
│  [검색 결과 3]           │
│                         │
└─────────────────────────┘
```

**구현 요소**:
- `SearchScreen` 위젯
- `TextField` (검색 입력창)
- `ListView` 또는 `GridView` (검색 결과)
- `CircularProgressIndicator` (로딩)
- `SnackBar` 또는 `AlertDialog` (에러 메시지)

## 네비게이션 흐름

### 1. 앱 시작 → Splash Screen
```dart
// main.dart
MaterialApp(
  home: SplashScreen(),
  routes: {
    '/main': (context) => MainScreen(),
    '/search': (context) => SearchScreen(),
  },
)
```

### 2. Splash Screen → Main Screen
```dart
// splash_screen.dart
Timer(Duration(seconds: 1), () {
  Navigator.pushReplacementNamed(context, '/main');
});
```

### 3. Main Screen → Search Screen
```dart
// main_screen.dart
onPressed: () async {
  // API 호출 시작
  showDialog(context: context, builder: (_) => LoadingDialog());
  
  try {
    await apiCall();
    Navigator.pop(context); // 로딩 다이얼로그 닫기
    Navigator.pushNamed(context, '/search');
  } catch (e) {
    Navigator.pop(context); // 로딩 다이얼로그 닫기
    showErrorDialog(context, e);
  }
}
```

## 상태 관리 (Bloc)

### 1. Splash Bloc
```dart
class SplashBloc extends Bloc<SplashEvent, SplashState> {
  SplashBloc() : super(SplashInitial()) {
    on<SplashStarted>(_onSplashStarted);
  }
}
```

### 2. Main Bloc
```dart
class MainBloc extends Bloc<MainEvent, MainState> {
  MainBloc() : super(MainInitial()) {
    on<SearchButtonPressed>(_onSearchButtonPressed);
  }
}
```

### 3. Search Bloc
```dart
class SearchBloc extends Bloc<SearchEvent, SearchState> {
  SearchBloc() : super(SearchInitial()) {
    on<SearchQueryChanged>(_onSearchQueryChanged);
    on<SearchSubmitted>(_onSearchSubmitted);
  }
}
```

## UI/UX 가이드라인

### 1. 색상 팔레트
- **Primary**: 건강한 녹색 계열 (#4CAF50)
- **Secondary**: 따뜻한 주황색 계열 (#FF9800)
- **Background**: 밝은 회색 계열 (#F5F5F5)
- **Text**: 진한 회색 계열 (#212121)

### 2. 타이포그래피
- **제목**: 24sp, Bold
- **부제목**: 18sp, Medium
- **본문**: 16sp, Regular
- **캡션**: 14sp, Regular

### 3. 간격 및 패딩
- **기본 패딩**: 16dp
- **카드 간격**: 8dp
- **버튼 높이**: 48dp
- **입력창 높이**: 56dp

### 4. 애니메이션
- **화면 전환**: 300ms 슬라이드 애니메이션
- **버튼 클릭**: 100ms 스케일 애니메이션
- **로딩**: 회전 애니메이션
