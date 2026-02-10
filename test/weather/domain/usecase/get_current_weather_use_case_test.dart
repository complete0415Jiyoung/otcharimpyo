import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:otcharimpyo/core/error/result.dart';
import 'package:otcharimpyo/core/error/failure.dart';
import 'package:otcharimpyo/weather/domain/model/weather.dart';
import 'package:otcharimpyo/weather/domain/repository/weather_repository.dart';
import 'package:otcharimpyo/weather/domain/usecase/get_current_weather_use_case.dart';

class MockWeatherRepository implements WeatherRepository {
  Result<Weather>? mockResult;

  @override
  Future<Result<Weather>> getCurrentWeather(double lat, double lon) async {
    return mockResult ?? const Error(Failure(FailureType.unknown, '기본 오류'));
  }
}

void main() {
  late GetCurrentWeatherUseCase useCase;
  late MockWeatherRepository mockRepository;

  setUp(() {
    mockRepository = MockWeatherRepository();
    useCase = GetCurrentWeatherUseCase(mockRepository);
  });

  group('GetCurrentWeatherUseCase', () {
    group('execute', () {
      test(
        'should return AsyncValue.data when repository returns Success',
        () async {
          const weather = Weather(
            temp: 25.5,
            description: '맑음',
            icon: '01d',
            feelsLike: 27.0,
            humidity: 60,
            precipitation: 0.0,
          );
          mockRepository.mockResult = const Success(weather);

          final result = await useCase.execute(37.5665, 126.9780);

          expect(result, isA<AsyncData<Weather>>());
          expect(result.value, weather);
        },
      );

      test(
        'should return AsyncValue.error when repository returns Error',
        () async {
          const failure = Failure(FailureType.network, '네트워크 오류');
          mockRepository.mockResult = const Error(failure);

          final result = await useCase.execute(37.5665, 126.9780);

          expect(result, isA<AsyncError<Weather>>());
          expect(result.error, failure);
        },
      );

      test('should pass correct coordinates to repository', () async {
        const weather = Weather(
          temp: 20.0,
          description: '흐림',
          icon: '04d',
          feelsLike: 19.0,
          humidity: 70,
          precipitation: 0.0,
        );
        mockRepository.mockResult = const Success(weather);

        final result = await useCase.execute(35.1796, 129.0756);

        expect(result.hasValue, isTrue);
      });

      test('should handle negative coordinates', () async {
        const weather = Weather(
          temp: 15.0,
          description: '맑음',
          icon: '01d',
          feelsLike: 14.0,
          humidity: 50,
          precipitation: 0.0,
        );
        mockRepository.mockResult = const Success(weather);

        final result = await useCase.execute(-33.8688, 151.2093);

        expect(result.hasValue, isTrue);
      });

      test(
        'should return error with correct failure type for timeout',
        () async {
          const failure = Failure(FailureType.timeout, '시간 초과');
          mockRepository.mockResult = const Error(failure);

          final result = await useCase.execute(37.5665, 126.9780);

          expect(result.hasError, isTrue);
          final error = result.error as Failure;
          expect(error.type, FailureType.timeout);
        },
      );

      test(
        'should return error with correct failure type for server error',
        () async {
          const failure = Failure(FailureType.server, '서버 오류');
          mockRepository.mockResult = const Error(failure);

          final result = await useCase.execute(37.5665, 126.9780);

          expect(result.hasError, isTrue);
          final error = result.error as Failure;
          expect(error.type, FailureType.server);
        },
      );
    });
  });
}
