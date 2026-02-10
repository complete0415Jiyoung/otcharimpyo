import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:otcharimpyo/weather/presentation/temperature_search_notifier.dart';
import 'package:otcharimpyo/weather/domain/model/outfit_item.dart';

void main() {
  group('TemperatureSearchNotifier', () {
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer();
    });

    tearDown(() {
      container.dispose();
    });

    group('build (initial state)', () {
      test('should have initial temperature of 12.0', () {
        final state = container.read(temperatureSearchNotifierProvider);

        expect(state.selectedTemperature, 12.0);
      });

      test('should have outfit items for 12 degrees', () {
        final state = container.read(temperatureSearchNotifierProvider);

        expect(state.tops, isNotEmpty);
        expect(state.bottoms, isNotEmpty);
        expect(state.outers, isNotEmpty);
      });

      test('should have tops containing 니트 and 맨투맨 for 12 degrees', () {
        final state = container.read(temperatureSearchNotifierProvider);

        final topNames = state.tops.map((e) => e.name).toList();
        expect(topNames, contains('니트'));
        expect(topNames, contains('맨투맨'));
      });
    });

    group('onTemperatureChanged', () {
      test('should update selectedTemperature', () {
        final notifier = container.read(temperatureSearchNotifierProvider.notifier);

        notifier.onTemperatureChanged(25.0);

        final state = container.read(temperatureSearchNotifierProvider);
        expect(state.selectedTemperature, 25.0);
      });

      test('should update outfit for hot weather (>= 28)', () {
        final notifier = container.read(temperatureSearchNotifierProvider.notifier);

        notifier.onTemperatureChanged(30.0);

        final state = container.read(temperatureSearchNotifierProvider);
        final topNames = state.tops.map((e) => e.name).toList();
        expect(topNames, contains('민소매'));
        expect(topNames, contains('반팔'));
        expect(state.outers, isEmpty);
      });

      test('should update outfit for warm weather (23-27)', () {
        final notifier = container.read(temperatureSearchNotifierProvider.notifier);

        notifier.onTemperatureChanged(25.0);

        final state = container.read(temperatureSearchNotifierProvider);
        final topNames = state.tops.map((e) => e.name).toList();
        expect(topNames, contains('반팔'));
        expect(topNames, contains('얇은 셔츠'));
      });

      test('should update outfit for mild weather (20-22)', () {
        final notifier = container.read(temperatureSearchNotifierProvider.notifier);

        notifier.onTemperatureChanged(21.0);

        final state = container.read(temperatureSearchNotifierProvider);
        final topNames = state.tops.map((e) => e.name).toList();
        expect(topNames, contains('긴팔티'));
        expect(state.outers, isNotEmpty);
      });

      test('should update outfit for cool weather (17-19)', () {
        final notifier = container.read(temperatureSearchNotifierProvider.notifier);

        notifier.onTemperatureChanged(18.0);

        final state = container.read(temperatureSearchNotifierProvider);
        final topNames = state.tops.map((e) => e.name).toList();
        expect(topNames, contains('얇은 니트'));
        expect(topNames, contains('맨투맨'));
      });

      test('should update outfit for chilly weather (12-16)', () {
        final notifier = container.read(temperatureSearchNotifierProvider.notifier);

        notifier.onTemperatureChanged(14.0);

        final state = container.read(temperatureSearchNotifierProvider);
        final outerNames = state.outers.map((e) => e.name).toList();
        expect(outerNames, contains('재킷'));
        expect(outerNames, contains('카디건'));
      });

      test('should update outfit for cold weather (9-11)', () {
        final notifier = container.read(temperatureSearchNotifierProvider.notifier);

        notifier.onTemperatureChanged(10.0);

        final state = container.read(temperatureSearchNotifierProvider);
        final outerNames = state.outers.map((e) => e.name).toList();
        expect(outerNames, contains('트렌치코트'));
      });

      test('should update outfit for very cold weather (5-8)', () {
        final notifier = container.read(temperatureSearchNotifierProvider.notifier);

        notifier.onTemperatureChanged(6.0);

        final state = container.read(temperatureSearchNotifierProvider);
        final outerNames = state.outers.map((e) => e.name).toList();
        expect(outerNames, contains('코트'));
      });

      test('should update outfit for freezing weather (1-4)', () {
        final notifier = container.read(temperatureSearchNotifierProvider.notifier);

        notifier.onTemperatureChanged(2.0);

        final state = container.read(temperatureSearchNotifierProvider);
        final outerNames = state.outers.map((e) => e.name).toList();
        expect(outerNames, contains('패딩'));
        expect(state.accessories, isNotEmpty);
      });

      test('should update outfit for sub-zero weather (-4 to 0)', () {
        final notifier = container.read(temperatureSearchNotifierProvider.notifier);

        notifier.onTemperatureChanged(-2.0);

        final state = container.read(temperatureSearchNotifierProvider);
        final outerNames = state.outers.map((e) => e.name).toList();
        expect(outerNames, contains('두꺼운 패딩'));
        final accessoryNames = state.accessories.map((e) => e.name).toList();
        expect(accessoryNames, contains('귀마개'));
      });

      test('should update outfit for extreme cold weather (< -4)', () {
        final notifier = container.read(temperatureSearchNotifierProvider.notifier);

        notifier.onTemperatureChanged(-10.0);

        final state = container.read(temperatureSearchNotifierProvider);
        final outerNames = state.outers.map((e) => e.name).toList();
        expect(outerNames, contains('파카'));
        final accessoryNames = state.accessories.map((e) => e.name).toList();
        expect(accessoryNames, contains('방한 아웃도어 제품'));
      });

      test('should categorize items correctly', () {
        final notifier = container.read(temperatureSearchNotifierProvider.notifier);

        notifier.onTemperatureChanged(15.0);

        final state = container.read(temperatureSearchNotifierProvider);

        for (final item in state.tops) {
          expect(item.category, OutfitCategory.top);
        }
        for (final item in state.bottoms) {
          expect(item.category, OutfitCategory.bottom);
        }
        for (final item in state.outers) {
          expect(item.category, OutfitCategory.outer);
        }
        for (final item in state.accessories) {
          expect(item.category, OutfitCategory.accessory);
        }
      });
    });
  });
}
