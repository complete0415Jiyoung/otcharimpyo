import 'package:flutter_test/flutter_test.dart';
import 'package:otcharimpyo/weather/presentation/temperature_search_state.dart';
import 'package:otcharimpyo/weather/domain/model/outfit_item.dart';

void main() {
  group('TemperatureSearchState', () {
    group('Default values', () {
      test('should have correct default values', () {
        const state = TemperatureSearchState();

        expect(state.selectedTemperature, 12.0);
        expect(state.tops, isEmpty);
        expect(state.bottoms, isEmpty);
        expect(state.outers, isEmpty);
        expect(state.accessories, isEmpty);
      });
    });

    group('Constructor with values', () {
      test('should create state with custom temperature', () {
        const state = TemperatureSearchState(selectedTemperature: 25.0);

        expect(state.selectedTemperature, 25.0);
      });

      test('should create state with outfit items', () {
        const tops = [OutfitItem(name: '반팔', category: OutfitCategory.top)];
        const bottoms = [OutfitItem(name: '반바지', category: OutfitCategory.bottom)];

        const state = TemperatureSearchState(
          selectedTemperature: 28.0,
          tops: tops,
          bottoms: bottoms,
        );

        expect(state.tops, tops);
        expect(state.bottoms, bottoms);
      });

      test('should create state with negative temperature', () {
        const state = TemperatureSearchState(selectedTemperature: -10.0);

        expect(state.selectedTemperature, -10.0);
      });
    });

    group('copyWith', () {
      test('should copy with new temperature', () {
        const original = TemperatureSearchState(selectedTemperature: 20.0);

        final copied = original.copyWith(selectedTemperature: 30.0);

        expect(copied.selectedTemperature, 30.0);
      });

      test('should copy with new tops', () {
        const original = TemperatureSearchState();
        const newTops = [OutfitItem(name: '니트', category: OutfitCategory.top)];

        final copied = original.copyWith(tops: newTops);

        expect(copied.tops, newTops);
        expect(copied.selectedTemperature, 12.0);
      });

      test('should copy with all outfit categories', () {
        const original = TemperatureSearchState();
        const tops = [OutfitItem(name: '스웨터', category: OutfitCategory.top)];
        const bottoms = [OutfitItem(name: '기모 바지', category: OutfitCategory.bottom)];
        const outers = [OutfitItem(name: '패딩', category: OutfitCategory.outer)];
        const accessories = [OutfitItem(name: '목도리', category: OutfitCategory.accessory)];

        final copied = original.copyWith(
          tops: tops,
          bottoms: bottoms,
          outers: outers,
          accessories: accessories,
        );

        expect(copied.tops, tops);
        expect(copied.bottoms, bottoms);
        expect(copied.outers, outers);
        expect(copied.accessories, accessories);
      });

      test('should preserve unchanged values', () {
        const original = TemperatureSearchState(
          selectedTemperature: 15.0,
          tops: [OutfitItem(name: '긴팔', category: OutfitCategory.top)],
        );

        final copied = original.copyWith(
          bottoms: [OutfitItem(name: '청바지', category: OutfitCategory.bottom)],
        );

        expect(copied.selectedTemperature, 15.0);
        expect(copied.tops.length, 1);
        expect(copied.bottoms.length, 1);
      });
    });

    group('Equality', () {
      test('should be equal when all fields are the same', () {
        const state1 = TemperatureSearchState(selectedTemperature: 20.0);
        const state2 = TemperatureSearchState(selectedTemperature: 20.0);

        expect(state1, equals(state2));
      });

      test('should not be equal when temperature differs', () {
        const state1 = TemperatureSearchState(selectedTemperature: 20.0);
        const state2 = TemperatureSearchState(selectedTemperature: 25.0);

        expect(state1, isNot(equals(state2)));
      });

      test('should be equal when outfit items are the same', () {
        const tops = [OutfitItem(name: '반팔', category: OutfitCategory.top)];
        const state1 = TemperatureSearchState(selectedTemperature: 28.0, tops: tops);
        const state2 = TemperatureSearchState(selectedTemperature: 28.0, tops: tops);

        expect(state1, equals(state2));
      });
    });
  });
}
