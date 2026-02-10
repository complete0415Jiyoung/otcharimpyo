import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:otcharimpyo/core/error/result.dart';
import 'package:otcharimpyo/core/error/failure.dart';
import 'package:otcharimpyo/weather/domain/model/weather.dart';
import 'package:otcharimpyo/weather/domain/model/outfit_item.dart';
import 'package:otcharimpyo/weather/domain/usecase/get_current_weather_use_case.dart';
import 'package:otcharimpyo/weather/domain/repository/weather_repository.dart';
import 'package:otcharimpyo/location/domain/model/location.dart';
import 'package:otcharimpyo/location/domain/usecase/get_current_location_use_case.dart';
import 'package:otcharimpyo/location/domain/repository/location_repository.dart';
import 'package:otcharimpyo/weather/presentation/outfit_notifier.dart';
import 'package:otcharimpyo/weather/presentation/outfit_state.dart';
import 'package:otcharimpyo/weather/presentation/outfit_action.dart';
import 'package:otcharimpyo/core/di/di_setup.dart';

class MockWeatherRepository implements WeatherRepository {
  Result<Weather>? mockResult;

  @override
  Future<Result<Weather>> getCurrentWeather(double lat, double lon) async {
    return mockResult ?? const Error(Failure(FailureType.unknown, '기본 오류'));
  }
}

class MockLocationRepository implements LocationRepository {
  Result<Location>? mockResult;

  @override
  Future<Result<Location>> getCurrentLocation() async {
    return mockResult ?? const Error(Failure(FailureType.unknown, '기본 오류'));
  }

  @override
  Future<Result<Location>> getLocationFromCoordinates(double lat, double lon) async {
    return mockResult ?? const Error(Failure(FailureType.unknown, '기본 오류'));
  }
}

void main() {
  group('OutfitNotifier', () {
    late MockWeatherRepository mockWeatherRepository;
    late MockLocationRepository mockLocationRepository;
    late GetCurrentWeatherUseCase weatherUseCase;
    late GetCurrentLocationUseCase locationUseCase;
    late ProviderContainer container;

    setUp(() {
      mockWeatherRepository = MockWeatherRepository();
      mockLocationRepository = MockLocationRepository();
      weatherUseCase = GetCurrentWeatherUseCase(mockWeatherRepository);
      locationUseCase = GetCurrentLocationUseCase(mockLocationRepository);

      // DI 초기화
      resetDi();
      getIt.registerSingleton<GetCurrentWeatherUseCase>(weatherUseCase);
      getIt.registerSingleton<GetCurrentLocationUseCase>(locationUseCase);

      container = ProviderContainer();
    });

    tearDown(() {
      container.dispose();
      resetDi();
    });

    group('build (initial state)', () {
      test('should have initial loading status', () {
        final state = container.read(outfitNotifierProvider);

        expect(state.loadingStatus, WeatherLoadingStatus.initial);
      });

      test('should have default temperature of 20.0', () {
        final state = container.read(outfitNotifierProvider);

        expect(state.temperature, 20.0);
      });

      test('should have empty outfit initially', () {
        final state = container.read(outfitNotifierProvider);

        expect(state.tops, isEmpty);
        expect(state.bottoms, isEmpty);
      });
    });

    group('onAction - OnChangeTemperature', () {
      test('should update outfit based on temperature', () async {
        final notifier = container.read(outfitNotifierProvider.notifier);

        await notifier.onAction(const OnChangeTemperature(30.0));

        final state = container.read(outfitNotifierProvider);
        expect(state.temperature, 30.0);
        expect(state.tops, isNotEmpty);
      });

      test('should have correct outfit for hot weather (>= 28)', () async {
        final notifier = container.read(outfitNotifierProvider.notifier);

        await notifier.onAction(const OnChangeTemperature(30.0));

        final state = container.read(outfitNotifierProvider);
        final topNames = state.tops.map((e) => e.name).toList();
        expect(topNames, contains('민소매'));
        expect(topNames, contains('반팔'));
        expect(state.outers, isEmpty);
      });

      test('should have correct outfit for warm weather (23-27)', () async {
        final notifier = container.read(outfitNotifierProvider.notifier);

        await notifier.onAction(const OnChangeTemperature(25.0));

        final state = container.read(outfitNotifierProvider);
        final topNames = state.tops.map((e) => e.name).toList();
        expect(topNames, contains('반팔'));
        expect(topNames, contains('얇은 셔츠'));
      });

      test('should have correct outfit for mild weather (20-22)', () async {
        final notifier = container.read(outfitNotifierProvider.notifier);

        await notifier.onAction(const OnChangeTemperature(21.0));

        final state = container.read(outfitNotifierProvider);
        final topNames = state.tops.map((e) => e.name).toList();
        expect(topNames, contains('긴팔티'));
        expect(state.outers.map((e) => e.name), contains('얇은 카디건'));
      });

      test('should have correct outfit for cool weather (17-19)', () async {
        final notifier = container.read(outfitNotifierProvider.notifier);

        await notifier.onAction(const OnChangeTemperature(18.0));

        final state = container.read(outfitNotifierProvider);
        expect(state.tops.map((e) => e.name), contains('얇은 니트'));
        expect(state.outers.map((e) => e.name), contains('카디건'));
      });

      test('should have correct outfit for chilly weather (12-16)', () async {
        final notifier = container.read(outfitNotifierProvider.notifier);

        await notifier.onAction(const OnChangeTemperature(14.0));

        final state = container.read(outfitNotifierProvider);
        expect(state.tops.map((e) => e.name), contains('니트'));
        expect(state.outers.map((e) => e.name), contains('재킷'));
      });

      test('should have correct outfit for cold weather (9-11)', () async {
        final notifier = container.read(outfitNotifierProvider.notifier);

        await notifier.onAction(const OnChangeTemperature(10.0));

        final state = container.read(outfitNotifierProvider);
        expect(state.outers.map((e) => e.name), contains('트렌치코트'));
      });

      test('should have correct outfit for very cold weather (5-8)', () async {
        final notifier = container.read(outfitNotifierProvider.notifier);

        await notifier.onAction(const OnChangeTemperature(6.0));

        final state = container.read(outfitNotifierProvider);
        expect(state.tops.map((e) => e.name), contains('히트텍'));
        expect(state.outers.map((e) => e.name), contains('코트'));
      });

      test('should have correct outfit for freezing weather (1-4)', () async {
        final notifier = container.read(outfitNotifierProvider.notifier);

        await notifier.onAction(const OnChangeTemperature(2.0));

        final state = container.read(outfitNotifierProvider);
        expect(state.outers.map((e) => e.name), contains('패딩'));
        expect(state.accessories.map((e) => e.name), contains('목도리'));
      });

      test('should have correct outfit for sub-zero weather (-4 to 0)', () async {
        final notifier = container.read(outfitNotifierProvider.notifier);

        await notifier.onAction(const OnChangeTemperature(-2.0));

        final state = container.read(outfitNotifierProvider);
        expect(state.outers.map((e) => e.name), contains('두꺼운 패딩'));
        expect(state.accessories.map((e) => e.name), contains('귀마개'));
      });

      test('should have correct outfit for extreme cold (< -4)', () async {
        final notifier = container.read(outfitNotifierProvider.notifier);

        await notifier.onAction(const OnChangeTemperature(-10.0));

        final state = container.read(outfitNotifierProvider);
        expect(state.outers.map((e) => e.name), contains('파카'));
        expect(state.accessories.map((e) => e.name), contains('방한 아웃도어 제품'));
      });

      test('should categorize all items correctly', () async {
        final notifier = container.read(outfitNotifierProvider.notifier);

        await notifier.onAction(const OnChangeTemperature(15.0));

        final state = container.read(outfitNotifierProvider);
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

    group('onAction - OnRefreshOutfit', () {
      test('should set loading status when refreshing', () async {
        mockLocationRepository.mockResult = const Error(
          Failure(FailureType.network, '네트워크 오류'),
        );

        final notifier = container.read(outfitNotifierProvider.notifier);

        // Start refresh
        final future = notifier.onAction(const OnRefreshOutfit());

        // Wait for completion
        await future;

        final state = container.read(outfitNotifierProvider);
        expect(state.loadingStatus, WeatherLoadingStatus.error);
      });

      test('should update state with weather data on success', () async {
        const location = Location(
          latitude: 37.5665,
          longitude: 126.9780,
          city: '서울특별시',
          district: '중구',
          dong: '명동',
        );
        const weather = Weather(
          temp: 25.0,
          description: '맑음',
          icon: '01d',
          feelsLike: 26.0,
          humidity: 50,
          precipitation: 0.0,
        );

        mockLocationRepository.mockResult = const Success(location);
        mockWeatherRepository.mockResult = const Success(weather);

        final notifier = container.read(outfitNotifierProvider.notifier);
        await notifier.onAction(const OnRefreshOutfit());

        final state = container.read(outfitNotifierProvider);
        expect(state.loadingStatus, WeatherLoadingStatus.success);
        expect(state.temperature, 25.0);
        expect(state.location, '서울특별시 중구 명동');
        expect(state.tops, isNotEmpty);
      });

      test('should handle location error', () async {
        mockLocationRepository.mockResult = const Error(
          Failure(FailureType.unauthorized, '위치 권한이 없습니다'),
        );

        final notifier = container.read(outfitNotifierProvider.notifier);
        await notifier.onAction(const OnRefreshOutfit());

        final state = container.read(outfitNotifierProvider);
        expect(state.loadingStatus, WeatherLoadingStatus.error);
        expect(state.errorMessage, isNotNull);
      });

      test('should handle weather error after location success', () async {
        const location = Location(
          latitude: 37.5665,
          longitude: 126.9780,
          city: '서울특별시',
          district: '중구',
          dong: '명동',
        );

        mockLocationRepository.mockResult = const Success(location);
        mockWeatherRepository.mockResult = const Error(
          Failure(FailureType.network, '날씨 정보 오류'),
        );

        final notifier = container.read(outfitNotifierProvider.notifier);
        await notifier.onAction(const OnRefreshOutfit());

        final state = container.read(outfitNotifierProvider);
        expect(state.loadingStatus, WeatherLoadingStatus.error);
      });
    });
  });
}
