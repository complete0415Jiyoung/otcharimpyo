import 'package:flutter_test/flutter_test.dart';
import 'package:otcharimpyo/weather/presentation/outfit_action.dart';

void main() {
  group('OutfitAction', () {
    group('OnChangeTemperature', () {
      test('should create with temperature value', () {
        const action = OnChangeTemperature(25.0);

        expect(action.temperature, 25.0);
      });

      test('should create with negative temperature', () {
        const action = OnChangeTemperature(-10.0);

        expect(action.temperature, -10.0);
      });

      test('should create with zero temperature', () {
        const action = OnChangeTemperature(0.0);

        expect(action.temperature, 0.0);
      });

      test('should be equal when temperature is the same', () {
        const action1 = OnChangeTemperature(25.0);
        const action2 = OnChangeTemperature(25.0);

        expect(action1, equals(action2));
      });

      test('should not be equal when temperature differs', () {
        const action1 = OnChangeTemperature(25.0);
        const action2 = OnChangeTemperature(30.0);

        expect(action1, isNot(equals(action2)));
      });

      test('should be an OutfitAction', () {
        const action = OnChangeTemperature(25.0);

        expect(action, isA<OutfitAction>());
      });
    });

    group('OnRefreshOutfit', () {
      test('should create OnRefreshOutfit', () {
        const action = OnRefreshOutfit();

        expect(action, isA<OnRefreshOutfit>());
      });

      test('should be equal to another OnRefreshOutfit', () {
        const action1 = OnRefreshOutfit();
        const action2 = OnRefreshOutfit();

        expect(action1, equals(action2));
      });

      test('should be an OutfitAction', () {
        const action = OnRefreshOutfit();

        expect(action, isA<OutfitAction>());
      });
    });

    group('Pattern matching', () {
      test('should match OnChangeTemperature correctly', () {
        const OutfitAction action = OnChangeTemperature(25.0);

        final result = switch (action) {
          OnChangeTemperature(:final temperature) => 'temp: $temperature',
          OnRefreshOutfit() => 'refresh',
          OnChangeLocation() => 'location',
          OnUseCurrentLocation() => 'current_location',
        };

        expect(result, 'temp: 25.0');
      });

      test('should match OnRefreshOutfit correctly', () {
        const OutfitAction action = OnRefreshOutfit();

        final result = switch (action) {
          OnChangeTemperature(:final temperature) => 'temp: $temperature',
          OnRefreshOutfit() => 'refresh',
          OnChangeLocation() => 'location',
          OnUseCurrentLocation() => 'current_location',
        };

        expect(result, 'refresh');
      });
    });
  });
}
