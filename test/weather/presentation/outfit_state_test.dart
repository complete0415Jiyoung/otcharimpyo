import 'package:flutter_test/flutter_test.dart';
import 'package:otcharimpyo/weather/presentation/outfit_state.dart';
import 'package:otcharimpyo/weather/domain/model/outfit_item.dart';

void main() {
  group('WeatherLoadingStatus', () {
    test('should have all expected statuses', () {
      expect(WeatherLoadingStatus.values, contains(WeatherLoadingStatus.initial));
      expect(WeatherLoadingStatus.values, contains(WeatherLoadingStatus.loading));
      expect(WeatherLoadingStatus.values, contains(WeatherLoadingStatus.success));
      expect(WeatherLoadingStatus.values, contains(WeatherLoadingStatus.error));
    });

    test('should have 4 statuses', () {
      expect(WeatherLoadingStatus.values.length, 4);
    });
  });

  group('OutfitState', () {
    group('Default values', () {
      test('should have correct default values', () {
        const state = OutfitState();

        expect(state.temperature, 20.0);
        expect(state.weatherDescription, '');
        expect(state.tops, isEmpty);
        expect(state.bottoms, isEmpty);
        expect(state.outers, isEmpty);
        expect(state.accessories, isEmpty);
        expect(state.lastUpdated, isNull);
        expect(state.loadingStatus, WeatherLoadingStatus.initial);
        expect(state.errorMessage, isNull);
        expect(state.location, '');
        expect(state.feelsLike, 0.0);
        expect(state.humidity, 0);
        expect(state.precipitation, 0.0);
        expect(state.weatherIcon, isNull);
      });
    });

    group('Constructor with values', () {
      test('should create state with custom values', () {
        final now = DateTime.now();
        const tops = [OutfitItem(name: '반팔', category: OutfitCategory.top)];
        const bottoms = [OutfitItem(name: '반바지', category: OutfitCategory.bottom)];

        final state = OutfitState(
          temperature: 28.0,
          weatherDescription: '맑음',
          tops: tops,
          bottoms: bottoms,
          outers: const [],
          accessories: const [],
          lastUpdated: now,
          loadingStatus: WeatherLoadingStatus.success,
          location: '서울특별시 중구',
          feelsLike: 30.0,
          humidity: 60,
          precipitation: 0.0,
          weatherIcon: '01d',
        );

        expect(state.temperature, 28.0);
        expect(state.weatherDescription, '맑음');
        expect(state.tops, tops);
        expect(state.bottoms, bottoms);
        expect(state.lastUpdated, now);
        expect(state.loadingStatus, WeatherLoadingStatus.success);
        expect(state.location, '서울특별시 중구');
        expect(state.feelsLike, 30.0);
        expect(state.humidity, 60);
        expect(state.weatherIcon, '01d');
      });
    });

    group('copyWith', () {
      test('should copy with new temperature', () {
        const original = OutfitState(temperature: 20.0);

        final copied = original.copyWith(temperature: 25.0);

        expect(copied.temperature, 25.0);
        expect(copied.loadingStatus, WeatherLoadingStatus.initial);
      });

      test('should copy with new loading status', () {
        const original = OutfitState();

        final copied = original.copyWith(loadingStatus: WeatherLoadingStatus.loading);

        expect(copied.loadingStatus, WeatherLoadingStatus.loading);
      });

      test('should copy with error message', () {
        const original = OutfitState();

        final copied = original.copyWith(
          loadingStatus: WeatherLoadingStatus.error,
          errorMessage: '네트워크 오류',
        );

        expect(copied.loadingStatus, WeatherLoadingStatus.error);
        expect(copied.errorMessage, '네트워크 오류');
      });

      test('should copy with outfit items', () {
        const original = OutfitState();
        const tops = [OutfitItem(name: '니트', category: OutfitCategory.top)];
        const outers = [OutfitItem(name: '패딩', category: OutfitCategory.outer)];

        final copied = original.copyWith(
          tops: tops,
          outers: outers,
        );

        expect(copied.tops, tops);
        expect(copied.outers, outers);
        expect(copied.bottoms, isEmpty);
      });

      test('should preserve unchanged values', () {
        final now = DateTime.now();
        final original = OutfitState(
          temperature: 25.0,
          location: '서울',
          lastUpdated: now,
        );

        final copied = original.copyWith(humidity: 70);

        expect(copied.temperature, 25.0);
        expect(copied.location, '서울');
        expect(copied.lastUpdated, now);
        expect(copied.humidity, 70);
      });
    });

    group('Equality', () {
      test('should be equal when all fields are the same', () {
        const state1 = OutfitState(temperature: 25.0, location: '서울');
        const state2 = OutfitState(temperature: 25.0, location: '서울');

        expect(state1, equals(state2));
      });

      test('should not be equal when fields differ', () {
        const state1 = OutfitState(temperature: 25.0);
        const state2 = OutfitState(temperature: 30.0);

        expect(state1, isNot(equals(state2)));
      });
    });
  });
}
