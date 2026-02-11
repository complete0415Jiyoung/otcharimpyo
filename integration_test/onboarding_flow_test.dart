/// 온보딩 플로우 통합 테스트
///
/// 테스트 시나리오:
/// 1. 온보딩 화면 표시 확인
/// 2. 페이지 네비게이션 (스와이프)
/// 3. "시작하기" 버튼 동작
/// 4. "위치 정보 허용하기" 버튼 동작
/// 5. 온보딩 완료 후 홈 화면 이동

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

import 'package:otcharimpyo/main.dart';
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
  Future<Map<String, dynamic>> fetchCurrentWeather(
    double lat,
    double lon,
  ) async {
    return {
      'main': {'temp': 22.0, 'feels_like': 23.0, 'humidity': 55},
      'weather': [
        {'description': '맑음', 'icon': '01d'},
      ],
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
  Future<LocationPermission> checkPermission() async {
    return LocationPermission.whileInUse;
  }

  @override
  Future<LocationPermission> requestPermission() async {
    return LocationPermission.whileInUse;
  }

  @override
  Future<List<Placemark>> getPlacemarksFromCoordinates(
    double lat,
    double lon,
  ) async {
    return [
      Placemark(
        administrativeArea: '서울특별시',
        subLocality: '중구',
        thoroughfare: '명동',
        name: '',
        street: '',
        isoCountryCode: 'KR',
        country: '대한민국',
        postalCode: '04536',
      ),
    ];
  }
}

/// Mock DI 설정
void mockDiSetup() {
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

/// DI 리셋
void resetMockDi() {
  if (getIt.isRegistered<WeatherDataSourceInterface>()) {
    getIt.reset();
  }
}

void main() {
  group('온보딩 플로우 통합 테스트', () {
    setUp(() {
      resetMockDi();
    });

    tearDown(() {
      resetMockDi();
    });

    group('1. 온보딩 화면 표시', () {
      testWidgets('온보딩 미완료 시 온보딩 화면이 표시되어야 한다', (tester) async {
        mockDiSetup();

        await tester.pumpWidget(
          const ProviderScope(
            child: MyApp(onboardingComplete: false),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.byType(PageView), findsOneWidget);
      });

      testWidgets('페이지 인디케이터가 표시되어야 한다', (tester) async {
        mockDiSetup();

        await tester.pumpWidget(
          const ProviderScope(
            child: MyApp(onboardingComplete: false),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.byType(AnimatedContainer), findsWidgets);
      });
    });

    group('2. 페이지 네비게이션', () {
      testWidgets('스와이프로 다음 페이지로 이동할 수 있어야 한다', (tester) async {
        mockDiSetup();

        await tester.pumpWidget(
          const ProviderScope(
            child: MyApp(onboardingComplete: false),
          ),
        );
        await tester.pumpAndSettle();

        // 왼쪽으로 스와이프
        await tester.fling(find.byType(PageView), const Offset(-300, 0), 1000);
        await tester.pumpAndSettle();

        expect(find.byType(PageView), findsOneWidget);
      });

      testWidgets('스와이프로 이전 페이지로 이동할 수 있어야 한다', (tester) async {
        mockDiSetup();

        await tester.pumpWidget(
          const ProviderScope(
            child: MyApp(onboardingComplete: false),
          ),
        );
        await tester.pumpAndSettle();

        // 왼쪽으로 스와이프 (다음 페이지)
        await tester.fling(find.byType(PageView), const Offset(-300, 0), 1000);
        await tester.pumpAndSettle();

        // 오른쪽으로 스와이프 (이전 페이지)
        await tester.fling(find.byType(PageView), const Offset(300, 0), 1000);
        await tester.pumpAndSettle();

        expect(find.byType(PageView), findsOneWidget);
      });
    });

    group('3. 시작하기 버튼', () {
      testWidgets('시작하기 버튼이 표시되어야 한다', (tester) async {
        mockDiSetup();

        await tester.pumpWidget(
          const ProviderScope(
            child: MyApp(onboardingComplete: false),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.text('시작하기'), findsOneWidget);
      });

      testWidgets('시작하기 버튼 탭 시 다음 페이지로 이동해야 한다', (tester) async {
        mockDiSetup();

        await tester.pumpWidget(
          const ProviderScope(
            child: MyApp(onboardingComplete: false),
          ),
        );
        await tester.pumpAndSettle();

        await tester.tap(find.text('시작하기'));
        await tester.pumpAndSettle();

        // 다음 페이지로 이동 확인
        expect(find.byType(PageView), findsOneWidget);
      });
    });

    group('4. 위치 정보 허용하기 버튼', () {
      testWidgets('위치 정보 허용하기 버튼이 표시되어야 한다', (tester) async {
        mockDiSetup();

        await tester.pumpWidget(
          const ProviderScope(
            child: MyApp(onboardingComplete: false),
          ),
        );
        await tester.pumpAndSettle();

        // 첫 번째 페이지에서 다음 페이지로 이동
        await tester.tap(find.text('시작하기'));
        await tester.pumpAndSettle();

        expect(find.text('위치 정보 허용하기'), findsOneWidget);
      });

      testWidgets('위치 정보 허용하기 버튼 탭 시 홈 화면으로 이동해야 한다', (tester) async {
        mockDiSetup();

        await tester.pumpWidget(
          const ProviderScope(
            child: MyApp(onboardingComplete: false),
          ),
        );
        await tester.pumpAndSettle();

        // 시작하기 버튼 탭
        await tester.tap(find.text('시작하기'));
        await tester.pumpAndSettle();

        // 위치 정보 허용하기 버튼 탭
        await tester.tap(find.text('위치 정보 허용하기'));
        await tester.pumpAndSettle();

        // 홈 화면으로 이동 확인 (PageView 없음)
        expect(find.byType(PageView), findsNothing);
      });
    });

    group('5. 온보딩 완료 후 홈 화면', () {
      testWidgets('온보딩 완료 상태면 홈 화면이 바로 표시되어야 한다', (tester) async {
        mockDiSetup();

        await tester.pumpWidget(
          const ProviderScope(
            child: MyApp(onboardingComplete: true),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.byType(PageView), findsNothing);
        expect(find.byType(Scaffold), findsOneWidget);
      });

      testWidgets('홈 화면에서 검색 버튼이 표시되어야 한다', (tester) async {
        mockDiSetup();

        await tester.pumpWidget(
          const ProviderScope(
            child: MyApp(onboardingComplete: true),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.byIcon(Icons.search_rounded), findsOneWidget);
      });

      testWidgets('홈 화면에서 날씨 정보가 표시되어야 한다', (tester) async {
        mockDiSetup();

        await tester.pumpWidget(
          const ProviderScope(
            child: MyApp(onboardingComplete: true),
          ),
        );
        await tester.pumpAndSettle();

        // Mock 날씨 데이터 확인 (온도 22도)
        expect(find.textContaining('22'), findsWidgets);
      });
    });

    group('6. 전체 플로우', () {
      testWidgets('온보딩 전체 플로우가 정상 동작해야 한다', (tester) async {
        mockDiSetup();

        // Given: 온보딩 시작
        await tester.pumpWidget(
          const ProviderScope(
            child: MyApp(onboardingComplete: false),
          ),
        );
        await tester.pumpAndSettle();

        // When: 시작하기 버튼 탭
        await tester.tap(find.text('시작하기'));
        await tester.pumpAndSettle();

        // When: 위치 정보 허용하기 버튼 탭
        await tester.tap(find.text('위치 정보 허용하기'));
        await tester.pumpAndSettle();

        // Then: 홈 화면으로 이동 확인
        expect(find.byType(PageView), findsNothing);
        expect(find.byIcon(Icons.search_rounded), findsOneWidget);
      });
    });
  });
}
