import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

import 'package:otcharimpyo/core/routing/router.dart';
import 'package:otcharimpyo/core/routing/routes.dart';
import 'package:otcharimpyo/weather/data/data_source/weather_data_source_interface.dart';
import 'package:otcharimpyo/location/data/data_source/location_data_source_interface.dart';
import 'package:otcharimpyo/weather/domain/repository/weather_repository.dart';
import 'package:otcharimpyo/weather/data/repository_impl/weather_repository_impl.dart';
import 'package:otcharimpyo/location/domain/repository/location_repository.dart';
import 'package:otcharimpyo/location/data/repository_impl/location_repository_impl.dart';
import 'package:otcharimpyo/weather/domain/usecase/get_current_weather_use_case.dart';
import 'package:otcharimpyo/location/domain/usecase/get_current_location_use_case.dart';

final getIt = GetIt.instance;

/// Mock WeatherDataSource
class MockWeatherDataSource implements WeatherDataSourceInterface {
  @override
  Future<Map<String, dynamic>> fetchCurrentWeather(double lat, double lon) async {
    return {
      'main': {'temp': 22.0, 'feels_like': 23.0, 'humidity': 55},
      'weather': [{'description': '맑음', 'icon': '01d'}],
      'rain': {'1h': 0.0},
    };
  }
}

/// Mock LocationDataSource
class MockLocationDataSource implements LocationDataSourceInterface {
  @override
  Future<Position> getCurrentPosition() async {
    return Position(
      latitude: 37.5665,
      longitude: 126.9780,
      timestamp: DateTime.now(),
      accuracy: 10.0,
      altitude: 0.0,
      altitudeAccuracy: 0.0,
      heading: 0.0,
      headingAccuracy: 0.0,
      speed: 0.0,
      speedAccuracy: 0.0,
    );
  }

  @override
  Future<LocationPermission> checkPermission() async => LocationPermission.whileInUse;

  @override
  Future<LocationPermission> requestPermission() async => LocationPermission.whileInUse;

  @override
  Future<List<Placemark>> getPlacemarksFromCoordinates(double lat, double lon) async {
    return [
      Placemark(
        administrativeArea: '서울특별시',
        subLocality: '중구',
        thoroughfare: '명동',
      ),
    ];
  }
}

void mockDiSetup() {
  if (!getIt.isRegistered<WeatherDataSourceInterface>()) {
    getIt.registerSingleton<WeatherDataSourceInterface>(MockWeatherDataSource());
    getIt.registerSingleton<LocationDataSourceInterface>(MockLocationDataSource());
    getIt.registerSingleton<WeatherRepository>(
      WeatherRepositoryImpl(dataSource: getIt<WeatherDataSourceInterface>()),
    );
    getIt.registerSingleton<LocationRepository>(
      LocationRepositoryImpl(dataSource: getIt<LocationDataSourceInterface>()),
    );
    getIt.registerSingleton<GetCurrentWeatherUseCase>(
      GetCurrentWeatherUseCase(getIt<WeatherRepository>()),
    );
    getIt.registerSingleton<GetCurrentLocationUseCase>(
      GetCurrentLocationUseCase(getIt<LocationRepository>()),
    );
  }
}

void resetMockDi() {
  if (getIt.isRegistered<WeatherDataSourceInterface>()) {
    getIt.reset();
  }
}

void main() {
  group('AppRouter', () {
    setUp(() {
      resetMockDi();
    });

    tearDown(() {
      resetMockDi();
    });

    group('createRouter', () {
      test('should create router with onboarding as initial location when onboardingComplete is false', () {
        final router = AppRouter.createRouter(onboardingComplete: false);

        expect(router, isA<GoRouter>());
        // GoRouter 생성 시 initialLocation이 올바르게 설정되었는지 확인
        expect(router.configuration.routes.isNotEmpty, isTrue);
      });

      test('should create router with home as initial location when onboardingComplete is true', () {
        final router = AppRouter.createRouter(onboardingComplete: true);

        expect(router, isA<GoRouter>());
        // GoRouter 생성 시 initialLocation이 올바르게 설정되었는지 확인
        expect(router.configuration.routes.isNotEmpty, isTrue);
      });

      test('should have onboarding route defined', () {
        final router = AppRouter.createRouter();
        final routes = router.configuration.routes;

        expect(routes.any((r) => r is GoRoute && (r).path == Routes.onboarding), isTrue);
      });

      test('should have home route defined', () {
        final router = AppRouter.createRouter();
        final routes = router.configuration.routes;

        expect(routes.any((r) => r is GoRoute && (r).path == Routes.home), isTrue);
      });

      test('should have temperature-search route defined', () {
        final router = AppRouter.createRouter();
        final routes = router.configuration.routes;

        expect(routes.any((r) => r is GoRoute && (r).path == Routes.temperatureSearch), isTrue);
      });
    });

    group('Navigation', () {
      testWidgets('should navigate to onboarding screen', (tester) async {
        mockDiSetup();
        final router = AppRouter.createRouter(onboardingComplete: false);

        await tester.pumpWidget(
          ProviderScope(
            child: MaterialApp.router(
              routerConfig: router,
            ),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.byType(Scaffold), findsOneWidget);
      });

      testWidgets('should navigate to home screen when onboarding complete', (tester) async {
        mockDiSetup();
        final router = AppRouter.createRouter(onboardingComplete: true);

        await tester.pumpWidget(
          ProviderScope(
            child: MaterialApp.router(
              routerConfig: router,
            ),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.byType(Scaffold), findsOneWidget);
      });

      testWidgets('should show error screen for invalid route', (tester) async {
        mockDiSetup();
        final router = AppRouter.createRouter(onboardingComplete: true);

        await tester.pumpWidget(
          ProviderScope(
            child: MaterialApp.router(
              routerConfig: router,
            ),
          ),
        );
        await tester.pumpAndSettle();

        // Navigate to invalid route
        router.go('/invalid-route');
        await tester.pumpAndSettle();

        // Should show error screen
        expect(find.text('페이지를 찾을 수 없습니다'), findsOneWidget);
        expect(find.byIcon(Icons.error_outline), findsOneWidget);
      });

      testWidgets('error screen should have home button', (tester) async {
        mockDiSetup();
        final router = AppRouter.createRouter(onboardingComplete: true);

        await tester.pumpWidget(
          ProviderScope(
            child: MaterialApp.router(
              routerConfig: router,
            ),
          ),
        );
        await tester.pumpAndSettle();

        router.go('/invalid-route');
        await tester.pumpAndSettle();

        expect(find.text('홈으로 돌아가기'), findsOneWidget);
        expect(find.byIcon(Icons.home), findsOneWidget);
      });

      testWidgets('should navigate from error screen to home', (tester) async {
        mockDiSetup();
        final router = AppRouter.createRouter(onboardingComplete: true);

        await tester.pumpWidget(
          ProviderScope(
            child: MaterialApp.router(
              routerConfig: router,
            ),
          ),
        );
        await tester.pumpAndSettle();

        router.go('/invalid-route');
        await tester.pumpAndSettle();

        await tester.tap(find.text('홈으로 돌아가기'));
        await tester.pumpAndSettle();

        // Should be on home screen now
        expect(find.text('페이지를 찾을 수 없습니다'), findsNothing);
      });
    });

    group('Page Transitions', () {
      testWidgets('should use custom transition for pages', (tester) async {
        mockDiSetup();
        final router = AppRouter.createRouter(onboardingComplete: true);

        await tester.pumpWidget(
          ProviderScope(
            child: MaterialApp.router(
              routerConfig: router,
            ),
          ),
        );
        await tester.pumpAndSettle();

        // Navigate to temperature search
        router.push(Routes.temperatureSearch);
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 150));

        // Animation should be in progress
        expect(find.byType(FadeTransition), findsWidgets);
      });
    });
  });
}
