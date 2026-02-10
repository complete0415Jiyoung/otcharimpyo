import 'package:flutter_test/flutter_test.dart';
import 'package:otcharimpyo/core/error/result.dart';
import 'package:otcharimpyo/core/error/failure.dart';

void main() {
  group('Result', () {
    group('Success', () {
      test('should hold a value', () {
        const result = Success<int>(42);

        expect(result.value, 42);
      });

      test('should hold string value', () {
        const result = Success<String>('test');

        expect(result.value, 'test');
      });

      test('should hold complex object', () {
        final testObject = {'key': 'value'};
        final result = Success<Map<String, String>>(testObject);

        expect(result.value, testObject);
        expect(result.value['key'], 'value');
      });

      test('should be a Result type', () {
        const result = Success<int>(42);

        expect(result, isA<Result<int>>());
      });
    });

    group('Error', () {
      test('should hold a Failure', () {
        const failure = Failure(FailureType.network, '네트워크 오류');
        const result = Error<int>(failure);

        expect(result.failure, failure);
        expect(result.failure.type, FailureType.network);
        expect(result.failure.message, '네트워크 오류');
      });

      test('should be a Result type', () {
        const failure = Failure(FailureType.unknown, '알 수 없는 오류');
        const result = Error<int>(failure);

        expect(result, isA<Result<int>>());
      });
    });

    group('Pattern matching', () {
      test('should match Success correctly', () {
        const Result<int> result = Success(42);

        final value = switch (result) {
          Success(:final value) => value,
          Error(:final failure) => failure.message,
        };

        expect(value, 42);
      });

      test('should match Error correctly', () {
        const Result<int> result = Error(
          Failure(FailureType.network, '네트워크 오류'),
        );

        final value = switch (result) {
          Success(:final value) => value.toString(),
          Error(:final failure) => failure.message,
        };

        expect(value, '네트워크 오류');
      });
    });
  });
}
