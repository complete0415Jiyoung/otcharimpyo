import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';

import 'package:otcharimpyo/core/di/di_setup.dart';
import 'package:otcharimpyo/weather/data/data_source/weather_data_source_interface.dart';
import 'package:otcharimpyo/location/data/data_source/location_data_source_interface.dart';
import 'package:otcharimpyo/weather/domain/repository/weather_repository.dart';
import 'package:otcharimpyo/location/domain/repository/location_repository.dart';
import 'package:otcharimpyo/weather/domain/usecase/get_current_weather_use_case.dart';
import 'package:otcharimpyo/location/domain/usecase/get_current_location_use_case.dart';
import 'package:otcharimpyo/weather/presentation/outfit_notifier.dart';

void main() {
  group('DI Setup', () {
    setUp(() {
      // Reset before each test
      if (GetIt.instance.isRegistered<WeatherDataSourceInterface>()) {
        GetIt.instance.reset();
      }
    });

    tearDown(() {
      // Clean up after tests
      if (GetIt.instance.isRegistered<WeatherDataSourceInterface>()) {
        resetDi();
      }
    });

    group('diSetup', () {
      test('should register WeatherDataSourceInterface', () {
        diSetup();

        expect(getIt.isRegistered<WeatherDataSourceInterface>(), isTrue);
        expect(getIt<WeatherDataSourceInterface>(), isA<WeatherDataSourceInterface>());
      });

      test('should register LocationDataSourceInterface', () {
        diSetup();

        expect(getIt.isRegistered<LocationDataSourceInterface>(), isTrue);
        expect(getIt<LocationDataSourceInterface>(), isA<LocationDataSourceInterface>());
      });

      test('should register WeatherRepository', () {
        diSetup();

        expect(getIt.isRegistered<WeatherRepository>(), isTrue);
        expect(getIt<WeatherRepository>(), isA<WeatherRepository>());
      });

      test('should register LocationRepository', () {
        diSetup();

        expect(getIt.isRegistered<LocationRepository>(), isTrue);
        expect(getIt<LocationRepository>(), isA<LocationRepository>());
      });

      test('should register GetCurrentWeatherUseCase', () {
        diSetup();

        expect(getIt.isRegistered<GetCurrentWeatherUseCase>(), isTrue);
        expect(getIt<GetCurrentWeatherUseCase>(), isA<GetCurrentWeatherUseCase>());
      });

      test('should register GetCurrentLocationUseCase', () {
        diSetup();

        expect(getIt.isRegistered<GetCurrentLocationUseCase>(), isTrue);
        expect(getIt<GetCurrentLocationUseCase>(), isA<GetCurrentLocationUseCase>());
      });

      test('should register OutfitNotifier as factory', () {
        diSetup();

        expect(getIt.isRegistered<OutfitNotifier>(), isTrue);

        // Factory returns new instance each time
        final notifier1 = getIt<OutfitNotifier>();
        final notifier2 = getIt<OutfitNotifier>();

        expect(notifier1, isNot(same(notifier2)));
      });
    });

    group('resetDi', () {
      test('should reset all registrations', () {
        diSetup();

        expect(getIt.isRegistered<WeatherDataSourceInterface>(), isTrue);

        resetDi();

        expect(getIt.isRegistered<WeatherDataSourceInterface>(), isFalse);
      });
    });

    group('Dependency Chain', () {
      test('should correctly wire dependencies', () {
        diSetup();

        // Verify the chain works
        final weatherRepo = getIt<WeatherRepository>();
        final locationRepo = getIt<LocationRepository>();
        final weatherUseCase = getIt<GetCurrentWeatherUseCase>();
        final locationUseCase = getIt<GetCurrentLocationUseCase>();
        final notifier = getIt<OutfitNotifier>();

        expect(weatherRepo, isNotNull);
        expect(locationRepo, isNotNull);
        expect(weatherUseCase, isNotNull);
        expect(locationUseCase, isNotNull);
        expect(notifier, isNotNull);
      });
    });
  });
}
