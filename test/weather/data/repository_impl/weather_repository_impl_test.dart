import 'package:flutter_test/flutter_test.dart';
import 'package:otcharimpyo/core/error/result.dart';
import 'package:otcharimpyo/core/error/failure.dart';
import 'package:otcharimpyo/weather/data/repository_impl/weather_repository_impl.dart';

import '../../../mocks/mock_data_sources.dart';

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
        mockDataSource.setMockResponse({
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
        });

        final result = await repository.getCurrentWeather(37.5665, 126.9780);

        expect(result, isA<Success>());
        final weather = (result as Success).value;
        expect(weather.temp, 25.5);
        expect(weather.description, '맑음');
      });

      test('should return Success with default values when data is minimal', () async {
        mockDataSource.setMockResponse({
          'main': {
            'temp': 20.0,
          },
        });

        final result = await repository.getCurrentWeather(37.5665, 126.9780);

        expect(result, isA<Success>());
        final weather = (result as Success).value;
        expect(weather.temp, 20.0);
        expect(weather.description, '');
        expect(weather.precipitation, 0.0);
      });

      test('should return Error when data source throws exception', () async {
        mockDataSource.setMockException(Exception('네트워크 오류'));

        final result = await repository.getCurrentWeather(37.5665, 126.9780);

        expect(result, isA<Error>());
        final failure = (result as Error).failure;
        expect(failure.type, FailureType.unknown);
      });

      test('should return Error with network failure when SocketException occurs', () async {
        mockDataSource.setMockException(Exception('SocketException: Connection failed'));

        final result = await repository.getCurrentWeather(37.5665, 126.9780);

        expect(result, isA<Error>());
        final failure = (result as Error).failure;
        expect(failure.type, FailureType.network);
      });

      test('should handle negative coordinates', () async {
        mockDataSource.setMockResponse({
          'main': {'temp': 15.0},
        });

        final result = await repository.getCurrentWeather(-33.8688, 151.2093);

        expect(result, isA<Success>());
      });

      test('should handle empty response', () async {
        mockDataSource.setMockResponse({});

        final result = await repository.getCurrentWeather(37.5665, 126.9780);

        expect(result, isA<Success>());
        final weather = (result as Success).value;
        expect(weather.temp, 0.0);
      });

      test('should handle server error exception', () async {
        mockDataSource.setMockException(Exception('날씨 정보를 가져오는데 실패했습니다 (500)'));

        final result = await repository.getCurrentWeather(37.5665, 126.9780);

        expect(result, isA<Error>());
        final failure = (result as Error).failure;
        expect(failure.type, FailureType.server);
      });

      test('should handle API key error', () async {
        mockDataSource.setMockException(Exception('API 키가 설정되지 않았습니다'));

        final result = await repository.getCurrentWeather(37.5665, 126.9780);

        expect(result, isA<Error>());
      });

      test('should parse complete weather data correctly', () async {
        mockDataSource.setMockResponse({
          'main': {
            'temp': 28.5,
            'feels_like': 32.0,
            'humidity': 80,
          },
          'weather': [
            {
              'description': '흐림',
              'icon': '04d',
            }
          ],
          'rain': {
            '1h': 2.5,
          },
        });

        final result = await repository.getCurrentWeather(37.5665, 126.9780);

        expect(result, isA<Success>());
        final weather = (result as Success).value;
        expect(weather.temp, 28.5);
        expect(weather.feelsLike, 32.0);
        expect(weather.humidity, 80);
        expect(weather.description, '흐림');
        expect(weather.icon, '04d');
        expect(weather.precipitation, 2.5);
      });
    });
  });
}
