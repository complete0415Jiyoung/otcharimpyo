import 'package:flutter_test/flutter_test.dart';
import 'package:otcharimpyo/weather/data/dto/weather_dto.dart';

void main() {
  group('WeatherDto', () {
    group('fromJson', () {
      test('should parse complete JSON correctly', () {
        final json = {
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
            '1h': 0.5,
          },
        };

        final dto = WeatherDto.fromJson(json);

        expect(dto.main?.temp, 25.5);
        expect(dto.main?.feelsLike, 27.0);
        expect(dto.main?.humidity, 60);
        expect(dto.weather?.first.description, '맑음');
        expect(dto.weather?.first.icon, '01d');
        expect(dto.rain?.oneHour, 0.5);
      });

      test('should handle missing rain data', () {
        final json = {
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
        };

        final dto = WeatherDto.fromJson(json);

        expect(dto.rain, isNull);
      });

      test('should handle missing weather data', () {
        final json = {
          'main': {
            'temp': 25.5,
            'feels_like': 27.0,
            'humidity': 60,
          },
        };

        final dto = WeatherDto.fromJson(json);

        expect(dto.weather, isNull);
      });

      test('should handle empty JSON', () {
        final json = <String, dynamic>{};

        final dto = WeatherDto.fromJson(json);

        expect(dto.main, isNull);
        expect(dto.weather, isNull);
        expect(dto.rain, isNull);
      });
    });
  });

  group('WeatherMainDto', () {
    group('fromJson', () {
      test('should parse all fields', () {
        final json = {
          'temp': 25.5,
          'feels_like': 27.0,
          'humidity': 60,
        };

        final dto = WeatherMainDto.fromJson(json);

        expect(dto.temp, 25.5);
        expect(dto.feelsLike, 27.0);
        expect(dto.humidity, 60);
      });

      test('should handle missing fields', () {
        final json = {
          'temp': 25.5,
        };

        final dto = WeatherMainDto.fromJson(json);

        expect(dto.temp, 25.5);
        expect(dto.feelsLike, isNull);
        expect(dto.humidity, isNull);
      });

      test('should handle negative temperature', () {
        final json = {
          'temp': -10.0,
          'feels_like': -15.0,
          'humidity': 80,
        };

        final dto = WeatherMainDto.fromJson(json);

        expect(dto.temp, -10.0);
        expect(dto.feelsLike, -15.0);
      });
    });
  });

  group('WeatherInfoDto', () {
    group('fromJson', () {
      test('should parse all fields', () {
        final json = {
          'description': '맑음',
          'icon': '01d',
        };

        final dto = WeatherInfoDto.fromJson(json);

        expect(dto.description, '맑음');
        expect(dto.icon, '01d');
      });

      test('should handle missing fields', () {
        final json = <String, dynamic>{};

        final dto = WeatherInfoDto.fromJson(json);

        expect(dto.description, isNull);
        expect(dto.icon, isNull);
      });
    });
  });

  group('WeatherRainDto', () {
    group('fromJson', () {
      test('should parse 1h field correctly', () {
        final json = {
          '1h': 5.5,
        };

        final dto = WeatherRainDto.fromJson(json);

        expect(dto.oneHour, 5.5);
      });

      test('should handle missing 1h field', () {
        final json = <String, dynamic>{};

        final dto = WeatherRainDto.fromJson(json);

        expect(dto.oneHour, isNull);
      });

      test('should handle zero rain', () {
        final json = {
          '1h': 0.0,
        };

        final dto = WeatherRainDto.fromJson(json);

        expect(dto.oneHour, 0.0);
      });
    });
  });
}
