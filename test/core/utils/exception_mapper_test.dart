import 'dart:async';
import 'package:flutter_test/flutter_test.dart';
import 'package:otcharimpyo/core/utils/exception_mapper.dart';
import 'package:otcharimpyo/core/error/failure.dart';

void main() {
  group('mapExceptionToFailure', () {
    test('should map TimeoutException to timeout failure', () {
      final exception = TimeoutException('시간 초과');
      final stackTrace = StackTrace.current;

      final failure = mapExceptionToFailure(exception, stackTrace);

      expect(failure.type, FailureType.timeout);
      expect(failure.message, '요청 시간이 초과되었습니다');
      expect(failure.cause, exception);
      expect(failure.stackTrace, stackTrace);
    });

    test('should map FormatException to parsing failure', () {
      const exception = FormatException('형식 오류');
      final stackTrace = StackTrace.current;

      final failure = mapExceptionToFailure(exception, stackTrace);

      expect(failure.type, FailureType.parsing);
      expect(failure.message, '데이터 형식 오류입니다');
      expect(failure.cause, exception);
    });

    test('should map SocketException string to network failure', () {
      final exception = Exception('SocketException: Connection failed');
      final stackTrace = StackTrace.current;

      final failure = mapExceptionToFailure(exception, stackTrace);

      expect(failure.type, FailureType.network);
      expect(failure.message, '인터넷 연결을 확인해주세요');
    });

    test('should map 401 error to unauthorized failure', () {
      final exception = Exception('HTTP Error 401: Unauthorized');
      final stackTrace = StackTrace.current;

      final failure = mapExceptionToFailure(exception, stackTrace);

      expect(failure.type, FailureType.unauthorized);
      expect(failure.message, '인증이 필요합니다');
    });

    test('should map 500 error to server failure', () {
      final exception = Exception('HTTP Error 500: Internal Server Error');
      final stackTrace = StackTrace.current;

      final failure = mapExceptionToFailure(exception, stackTrace);

      expect(failure.type, FailureType.server);
      expect(failure.message, '서버 오류가 발생했습니다');
    });

    test('should map unknown exception to unknown failure', () {
      final exception = Exception('알 수 없는 오류');
      final stackTrace = StackTrace.current;

      final failure = mapExceptionToFailure(exception, stackTrace);

      expect(failure.type, FailureType.unknown);
      expect(failure.message, '알 수 없는 오류가 발생했습니다');
    });

    test('should preserve stackTrace in all cases', () {
      final exception = Exception('테스트 오류');
      final stackTrace = StackTrace.current;

      final failure = mapExceptionToFailure(exception, stackTrace);

      expect(failure.stackTrace, stackTrace);
    });
  });
}
