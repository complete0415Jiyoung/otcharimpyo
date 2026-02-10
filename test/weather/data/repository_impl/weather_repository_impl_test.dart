import 'package:flutter_test/flutter_test.dart';
import 'package:otcharimpyo/core/error/result.dart';
import 'package:otcharimpyo/core/error/failure.dart';
import 'package:otcharimpyo/weather/data/data_source/weather_data_source.dart';
import 'package:otcharimpyo/weather/data/repository_impl/weather_repository_impl.dart';

class MockWeatherDataSource extends WeatherDataSource {
  Map<String, dynamic>? mockResponse;
  Exception? mockException;

  @override
  Future<Map<String, dynamic>> fetchCurrentWeather(
    double lat,
    double lon,
  ) async {
    if (mockException != null) {
      throw mockException!;
    }
    return mockResponse ?? {};
  }
}

void main() {
  late WeatherRepositoryImpl repository;
  late MockWeatherDataSource mockDataSource;

  setUp(() {
    mockDataSource = MockWeatherDataSource();
    repository = WeatherRepositoryImpl(dataSource: mockDataSource);
  });

  group('WeatherRepositoryImpl', () {
    group('getCurrentWeather', () {
      test('should return Success with Weather when data source returns valid data', () async {
        mockDataSource.mockResponse = {
          'main': {
            'temp': 25.5,
            'feels_like': 27.0,
            'humidity': 60,
          },
          'weather': [
            {
              'description': '맑음',
              'icon': '01d',
            }
          ],
          'rain': {
            '1h': 0.0,
          },
        };

        final result = await repository.getCurrentWeather(37.5665, 126.9780);

        expect(result, isA<Success>());
        final weather = (result as Success).value;
        expect(weather.temp, 25.5);
        expect(weather.description, '맑음');
      });

      test('should return Success with default values when data is minimal', () async {
        mockDataSource.mockResponse = {
          'main': {
            'temp': 20.0,
          },
        };

        final result = await repository.getCurrentWeather(37.5665, 126.9780);

        expect(result, isA<Success>());
        final weather = (result as Success).value;
        expect(weather.temp, 20.0);
        expect(weather.description, '');
        expect(weather.precipitation, 0.0);
      });

      test('should return Error when data source throws exception', () async {
        mockDataSource.mockException = Exception('네트워크 오류');

        final result = await repository.getCurrentWeather(37.5665, 126.9780);

        expect(result, isA<Error>());
        final failure = (result as Error).failure;
        expect(failure.type, FailureType.unknown);
      });

      test('should return Error with timeout failure when TimeoutException occurs', () async {
        mockDataSource.mockException = Exception('SocketException: Connection failed');

        final result = await repository.getCurrentWeather(37.5665, 126.9780);

        expect(result, isA<Error>());
        final failure = (result as Error).failure;
        expect(failure.type, FailureType.network);
      });

      test('should handle negative coordinates', () async {
        mockDataSource.mockResponse = {
          'main': {'temp': 15.0},
        };

        final result = await repository.getCurrentWeather(-33.8688, 151.2093);

        expect(result, isA<Success>());
      });

      test('should handle empty response', () async {
        mockDataSource.mockResponse = {};

        final result = await repository.getCurrentWeather(37.5665, 126.9780);

        expect(result, isA<Success>());
        final weather = (result as Success).value;
        expect(weather.temp, 0.0);
      });
    });
  });
}
