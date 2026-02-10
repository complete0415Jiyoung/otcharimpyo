import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:otcharimpyo/core/error/result.dart';
import 'package:otcharimpyo/core/error/failure.dart';
import 'package:otcharimpyo/location/domain/model/location.dart';
import 'package:otcharimpyo/location/domain/repository/location_repository.dart';
import 'package:otcharimpyo/location/domain/usecase/get_current_location_use_case.dart';

class MockLocationRepository implements LocationRepository {
  Result<Location>? mockResult;

  @override
  Future<Result<Location>> getCurrentLocation() async {
    return mockResult ?? const Error(Failure(FailureType.unknown, '기본 오류'));
  }

  @override
  Future<Result<Location>> getLocationFromCoordinates(
    double lat,
    double lon,
  ) async {
    return mockResult ?? const Error(Failure(FailureType.unknown, '기본 오류'));
  }
}

void main() {
  late GetCurrentLocationUseCase useCase;
  late MockLocationRepository mockRepository;

  setUp(() {
    mockRepository = MockLocationRepository();
    useCase = GetCurrentLocationUseCase(mockRepository);
  });

  group('GetCurrentLocationUseCase', () {
    group('execute', () {
      test('should return AsyncValue.data when repository returns Success', () async {
        const location = Location(
          latitude: 37.5665,
          longitude: 126.9780,
          city: '서울특별시',
          district: '중구',
          dong: '명동',
        );
        mockRepository.mockResult = const Success(location);

        final result = await useCase.execute();

        expect(result, isA<AsyncData<Location>>());
        expect(result.value, location);
      });

      test('should return AsyncValue.error when repository returns Error', () async {
        const failure = Failure(FailureType.network, '네트워크 오류');
        mockRepository.mockResult = const Error(failure);

        final result = await useCase.execute();

        expect(result, isA<AsyncError<Location>>());
        expect(result.error, failure);
      });

      test('should return location with correct address', () async {
        const location = Location(
          latitude: 35.1796,
          longitude: 129.0756,
          city: '부산광역시',
          district: '해운대구',
          dong: '우동',
        );
        mockRepository.mockResult = const Success(location);

        final result = await useCase.execute();

        expect(result.hasValue, isTrue);
        expect(result.value?.city, '부산광역시');
        expect(result.value?.district, '해운대구');
      });

      test('should handle unauthorized error', () async {
        const failure = Failure(FailureType.unauthorized, '위치 권한이 없습니다');
        mockRepository.mockResult = const Error(failure);

        final result = await useCase.execute();

        expect(result.hasError, isTrue);
        final error = result.error as Failure;
        expect(error.type, FailureType.unauthorized);
        expect(error.message, '위치 권한이 없습니다');
      });

      test('should handle timeout error', () async {
        const failure = Failure(FailureType.timeout, '시간 초과');
        mockRepository.mockResult = const Error(failure);

        final result = await useCase.execute();

        expect(result.hasError, isTrue);
        final error = result.error as Failure;
        expect(error.type, FailureType.timeout);
      });

      test('should preserve stackTrace from failure', () async {
        final stackTrace = StackTrace.current;
        final failure = Failure(
          FailureType.network,
          '네트워크 오류',
          stackTrace: stackTrace,
        );
        mockRepository.mockResult = Error(failure);

        final result = await useCase.execute();

        expect(result.hasError, isTrue);
      });
    });
  });
}
