import 'package:flutter_test/flutter_test.dart';
import 'package:otcharimpyo/core/error/failure.dart';

void main() {
  group('Failure', () {
    group('Constructor', () {
      test('should create with type and message', () {
        const failure = Failure(FailureType.network, '네트워크 오류');

        expect(failure.type, FailureType.network);
        expect(failure.message, '네트워크 오류');
        expect(failure.cause, isNull);
        expect(failure.stackTrace, isNull);
      });

      test('should create with optional cause', () {
        final cause = Exception('원인');
        final failure = Failure(
          FailureType.server,
          '서버 오류',
          cause: cause,
        );

        expect(failure.type, FailureType.server);
        expect(failure.message, '서버 오류');
        expect(failure.cause, cause);
      });

      test('should create with optional stackTrace', () {
        final stackTrace = StackTrace.current;
        final failure = Failure(
          FailureType.parsing,
          '파싱 오류',
          stackTrace: stackTrace,
        );

        expect(failure.stackTrace, stackTrace);
      });
    });

    group('isNetwork', () {
      test('should return true for network failure', () {
        const failure = Failure(FailureType.network, '네트워크 오류');

        expect(failure.isNetwork, isTrue);
      });

      test('should return false for other failure types', () {
        const failure = Failure(FailureType.server, '서버 오류');

        expect(failure.isNetwork, isFalse);
      });
    });

    group('isTimeout', () {
      test('should return true for timeout failure', () {
        const failure = Failure(FailureType.timeout, '시간 초과');

        expect(failure.isTimeout, isTrue);
      });

      test('should return false for other failure types', () {
        const failure = Failure(FailureType.network, '네트워크 오류');

        expect(failure.isTimeout, isFalse);
      });
    });

    group('isUnauthorized', () {
      test('should return true for unauthorized failure', () {
        const failure = Failure(FailureType.unauthorized, '인증 필요');

        expect(failure.isUnauthorized, isTrue);
      });

      test('should return false for other failure types', () {
        const failure = Failure(FailureType.network, '네트워크 오류');

        expect(failure.isUnauthorized, isFalse);
      });
    });
  });

  group('FailureType', () {
    test('should have all expected types', () {
      expect(FailureType.values, contains(FailureType.network));
      expect(FailureType.values, contains(FailureType.unauthorized));
      expect(FailureType.values, contains(FailureType.timeout));
      expect(FailureType.values, contains(FailureType.server));
      expect(FailureType.values, contains(FailureType.parsing));
      expect(FailureType.values, contains(FailureType.unknown));
    });

    test('should have 6 types', () {
      expect(FailureType.values.length, 6);
    });
  });
}
