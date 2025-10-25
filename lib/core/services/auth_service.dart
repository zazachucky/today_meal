import 'package:shared_preferences/shared_preferences.dart';

/// 사용자 정보 모델
class UserData {
  final String email;
  final String name;
  final String password; // 실제 앱에서는 해시된 비밀번호 저장

  UserData({
    required this.email,
    required this.name,
    required this.password,
  });

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'name': name,
      'password': password,
    };
  }

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      email: json['email'],
      name: json['name'],
      password: json['password'],
    );
  }
}

/// 로그인 상태 관리 서비스
class AuthService {
  static const String _isLoggedInKey = 'is_logged_in';
  static const String _userEmailKey = 'user_email';
  static const String _userNameKey = 'user_name';
  static const String _registeredUsersKey = 'registered_users';

  /// 테스트용 사용자 데이터 초기화
  static Future<void> initializeTestUsers() async {
    final prefs = await SharedPreferences.getInstance();
    final existingUsers = prefs.getString(_registeredUsersKey);

    if (existingUsers == null) {
      // 테스트용 사용자 데이터 생성
      final testUsers = {
        'test@example.com': UserData(
          email: 'test@example.com',
          name: '테스트 사용자',
          password: '123456', // 실제 앱에서는 해시된 비밀번호 사용
        ).toJson(),
        'admin@example.com': UserData(
          email: 'admin@example.com',
          name: '관리자',
          password: 'admin123',
        ).toJson(),
      };

      await prefs.setString(_registeredUsersKey, testUsers.toString());
    }
  }

  /// 등록된 사용자 데이터 가져오기
  static Future<Map<String, UserData>> getRegisteredUsers() async {
    final prefs = await SharedPreferences.getInstance();
    final usersString = prefs.getString(_registeredUsersKey);

    if (usersString == null) return {};

    // 간단한 파싱 (실제 앱에서는 JSON 직렬화 라이브러리 사용)
    final users = <String, UserData>{};

    // 테스트용 하드코딩된 사용자들
    users['test@example.com'] = UserData(
      email: 'test@example.com',
      name: '테스트 사용자',
      password: '123456',
    );

    users['admin@example.com'] = UserData(
      email: 'admin@example.com',
      name: '관리자',
      password: 'admin123',
    );

    return users;
  }

  /// 사용자 인증
  static Future<bool> authenticateUser({
    required String email,
    required String password,
  }) async {
    final users = await getRegisteredUsers();
    final user = users[email];

    if (user == null) {
      return false; // 사용자가 존재하지 않음
    }

    return user.password == password; // 비밀번호 확인
  }

  /// 로그인 상태 확인
  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_isLoggedInKey) ?? false;
  }

  /// 사용자 이메일 가져오기
  static Future<String?> getUserEmail() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_userEmailKey);
  }

  /// 사용자 이름 가져오기
  static Future<String?> getUserName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_userNameKey);
  }

  /// 로그인 처리
  static Future<void> login({
    required String email,
    required String name,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_isLoggedInKey, true);
    await prefs.setString(_userEmailKey, email);
    await prefs.setString(_userNameKey, name);
  }

  /// 로그아웃 처리
  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_isLoggedInKey);
    await prefs.remove(_userEmailKey);
    await prefs.remove(_userNameKey);
  }
}
