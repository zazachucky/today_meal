import 'package:equatable/equatable.dart';

/// 실패 타입 정의
abstract class Failure extends Equatable {
  final String message;

  const Failure(this.message);

  @override
  List<Object> get props => [message];
}

/// 서버 실패
class ServerFailure extends Failure {
  const ServerFailure(super.message);
}

/// 네트워크 실패
class NetworkFailure extends Failure {
  const NetworkFailure(super.message);
}

/// 캐시 실패
class CacheFailure extends Failure {
  const CacheFailure(super.message);
}

/// 잘못된 입력 실패
class InvalidInputFailure extends Failure {
  const InvalidInputFailure(super.message);
}

/// 인증 실패
class AuthFailure extends Failure {
  const AuthFailure(super.message);
}

/// 권한 실패
class PermissionFailure extends Failure {
  const PermissionFailure(super.message);
}

/// 데이터를 찾을 수 없음 실패
class NotFoundFailure extends Failure {
  const NotFoundFailure(super.message);
}
