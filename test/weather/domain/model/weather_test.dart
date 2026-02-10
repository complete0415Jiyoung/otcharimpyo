import 'package:flutter_test/flutter_test.dart';
import 'package:otcharimpyo/weather/domain/model/weather.dart';

void main() {
  group('Weather', () {
    group('Constructor', () {
      test('should create Weather with all required fields', () {
        const weather = Weather(
          temp: 25.5,
          description: '맑음',
          icon: '01d',
          feelsLike: 27.0,
          humidity: 60,
          precipitation: 0.0,
        );

        expect(weather.temp, 25.5);
        expect(weather.description, '맑음');
        expect(weather.icon, '01d');
        expect(weather.feelsLike, 27.0);
        expect(weather.humidity, 60);
        expect(weather.precipitation, 0.0);
      });

      test('should create Weather with negative temperature', () {
        const weather = Weather(
          temp: -10.0,
          description: '눈',
          icon: '13d',
          feelsLike: -15.0,
          humidity: 80,
          precipitation: 5.0,
        );

        expect(weather.temp, -10.0);
        expect(weather.feelsLike, -15.0);
      });

      test('should create Weather with high precipitation', () {
        const weather = Weather(
          temp: 20.0,
          description: '비',
          icon: '10d',
          feelsLike: 18.0,
          humidity: 95,
          precipitation: 15.5,
        );

        expect(weather.precipitation, 15.5);
        expect(weather.humidity, 95);
      });
    });

    group('Equality', () {
      test('should be equal when all fields are the same', () {
        const weather1 = Weather(
          temp: 25.0,
          description: '맑음',
          icon: '01d',
          feelsLike: 26.0,
          humidity: 50,
          precipitation: 0.0,
        );
        const weather2 = Weather(
          temp: 25.0,
          description: '맑음',
          icon: '01d',
          feelsLike: 26.0,
          humidity: 50,
          precipitation: 0.0,
        );

        expect(weather1, equals(weather2));
      });

      test('should not be equal when fields differ', () {
        const weather1 = Weather(
          temp: 25.0,
          description: '맑음',
          icon: '01d',
          feelsLike: 26.0,
          humidity: 50,
          precipitation: 0.0,
        );
        const weather2 = Weather(
          temp: 26.0,
          description: '맑음',
          icon: '01d',
          feelsLike: 27.0,
          humidity: 50,
          precipitation: 0.0,
        );

        expect(weather1, isNot(equals(weather2)));
      });
    });

    group('copyWith', () {
      test('should copy with new temperature', () {
        const original = Weather(
          temp: 25.0,
          description: '맑음',
          icon: '01d',
          feelsLike: 26.0,
          humidity: 50,
          precipitation: 0.0,
        );

        final copied = original.copyWith(temp: 30.0);

        expect(copied.temp, 30.0);
        expect(copied.description, '맑음');
        expect(copied.icon, '01d');
      });

      test('should keep original values when not specified', () {
        const original = Weather(
          temp: 25.0,
          description: '맑음',
          icon: '01d',
          feelsLike: 26.0,
          humidity: 50,
          precipitation: 0.0,
        );

        final copied = original.copyWith();

        expect(copied, equals(original));
      });
    });
  });
}
