import 'dart:async';
import '../error/failure.dart';

Failure mapExceptionToFailure(Object error, StackTrace stackTrace) {
  if (error is TimeoutException) {
    return Failure(
      FailureType.timeout,
      '요청 시간이 초과되었습니다',
      cause: error,
      stackTrace: stackTrace,
    );
  } else if (error is FormatException) {
    return Failure(
      FailureType.parsing,
      '데이터 형식 오류입니다',
      cause: error,
      stackTrace: stackTrace,
    );
  } else if (error.toString().contains('SocketException')) {
    return Failure(
      FailureType.network,
      '인터넷 연결을 확인해주세요',
      cause: error,
      stackTrace: stackTrace,
    );
  } else if (error.toString().contains('401')) {
    return Failure(
      FailureType.unauthorized,
      '인증이 필요합니다',
      cause: error,
      stackTrace: stackTrace,
    );
  } else if (error.toString().contains('500')) {
    return Failure(
      FailureType.server,
      '서버 오류가 발생했습니다',
      cause: error,
      stackTrace: stackTrace,
    );
  } else {
    return Failure(
      FailureType.unknown,
      '알 수 없는 오류가 발생했습니다',
      cause: error,
      stackTrace: stackTrace,
    );
  }
}
