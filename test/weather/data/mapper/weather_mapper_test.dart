import 'package:flutter_test/flutter_test.dart';
import 'package:otcharimpyo/weather/data/dto/weather_dto.dart';
import 'package:otcharimpyo/weather/data/mapper/weather_mapper.dart';

void main() {
  group('WeatherDtoMapper', () {
    group('toModel', () {
      test('should convert complete DTO to Weather model', () {
        final dto = WeatherDto(
          main: WeatherMainDto(
            temp: 25.5,
            feelsLike: 27.0,
            humidity: 60,
          ),
          weather: [
            WeatherInfoDto(
              description: '맑음',
              icon: '01d',
            ),
          ],
          rain: WeatherRainDto(oneHour: 0.5),
        );

        final weather = dto.toModel();

        expect(weather.temp, 25.5);
        expect(weather.feelsLike, 27.0);
        expect(weather.humidity, 60);
        expect(weather.description, '맑음');
        expect(weather.icon, '01d');
        expect(weather.precipitation, 0.5);
      });

      test('should use default values when main is null', () {
        final dto = WeatherDto(
          main: null,
          weather: [
            WeatherInfoDto(
              description: '흐림',
              icon: '04d',
            ),
          ],
        );

        final weather = dto.toModel();

        expect(weather.temp, 0.0);
        expect(weather.feelsLike, 0.0);
        expect(weather.humidity, 0);
      });

      test('should use default values when weather list is null', () {
        final dto = WeatherDto(
          main: WeatherMainDto(
            temp: 20.0,
            feelsLike: 21.0,
            humidity: 50,
          ),
          weather: null,
        );

        final weather = dto.toModel();

        expect(weather.description, '');
        expect(weather.icon, '');
      });

      test('should use default values when weather list is empty', () {
        final dto = WeatherDto(
          main: WeatherMainDto(
            temp: 20.0,
            feelsLike: 21.0,
            humidity: 50,
          ),
          weather: [],
        );

        final weather = dto.toModel();

        expect(weather.description, '');
        expect(weather.icon, '');
      });

      test('should use default precipitation when rain is null', () {
        final dto = WeatherDto(
          main: WeatherMainDto(
            temp: 20.0,
            feelsLike: 21.0,
            humidity: 50,
          ),
          weather: [
            WeatherInfoDto(
              description: '맑음',
              icon: '01d',
            ),
          ],
          rain: null,
        );

        final weather = dto.toModel();

        expect(weather.precipitation, 0.0);
      });

      test('should use temp as feelsLike when feelsLike is null', () {
        final dto = WeatherDto(
          main: WeatherMainDto(
            temp: 20.0,
            feelsLike: null,
            humidity: 50,
          ),
          weather: [],
        );

        final weather = dto.toModel();

        expect(weather.temp, 20.0);
        expect(weather.feelsLike, 20.0);
      });

      test('should handle all null values', () {
        final dto = WeatherDto(
          main: null,
          weather: null,
          rain: null,
        );

        final weather = dto.toModel();

        expect(weather.temp, 0.0);
        expect(weather.feelsLike, 0.0);
        expect(weather.humidity, 0);
        expect(weather.description, '');
        expect(weather.icon, '');
        expect(weather.precipitation, 0.0);
      });

      test('should handle negative temperatures', () {
        final dto = WeatherDto(
          main: WeatherMainDto(
            temp: -10.0,
            feelsLike: -15.0,
            humidity: 80,
          ),
          weather: [
            WeatherInfoDto(
              description: '눈',
              icon: '13d',
            ),
          ],
        );

        final weather = dto.toModel();

        expect(weather.temp, -10.0);
        expect(weather.feelsLike, -15.0);
      });
    });
  });
}
