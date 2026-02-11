/// DI 및 라우팅 통합 테스트
///
/// 테스트 시나리오:
/// 1. DI 초기화 확인
/// 2. 모든 의존성 주입 확인
/// 3. 라우팅 테스트 (온보딩 → 홈 → 온도 검색)

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
  group('DI 및 라우팅 통합 테스트', () {
    setUp(() {
      resetMockDi();
    });

    tearDown(() {
      resetMockDi();
    });

    group('1. DI 초기화 확인', () {
      testWidgets('GetIt이 초기화되어야 한다', (tester) async {
        mockDiSetup();

        expect(getIt.isRegistered<WeatherDataSourceInterface>(), isTrue);
      });

      testWidgets('모든 필수 의존성이 등록되어야 한다', (tester) async {
        mockDiSetup();

        expect(getIt.isRegistered<WeatherDataSourceInterface>(), isTrue);
        expect(getIt.isRegistered<LocationDataSourceInterface>(), isTrue);
        expect(getIt.isRegistered<WeatherRepository>(), isTrue);
        expect(getIt.isRegistered<LocationRepository>(), isTrue);
        expect(getIt.isRegistered<GetCurrentWeatherUseCase>(), isTrue);
        expect(getIt.isRegistered<GetCurrentLocationUseCase>(), isTrue);
      });
    });

    group('2. 의존성 주입 동작 확인', () {
      testWidgets('WeatherDataSource가 올바르게 주입되어야 한다', (tester) async {
        mockDiSetup();

        final weatherDataSource = getIt<WeatherDataSourceInterface>();
        expect(weatherDataSource, isNotNull);
        expect(weatherDataSource, isA<WeatherDataSourceInterface>());
      });

      testWidgets('LocationDataSource가 올바르게 주입되어야 한다', (tester) async {
        mockDiSetup();

        final locationDataSource = getIt<LocationDataSourceInterface>();
        expect(locationDataSource, isNotNull);
        expect(locationDataSource, isA<LocationDataSourceInterface>());
      });

      testWidgets('WeatherRepository가 올바르게 주입되어야 한다', (tester) async {
        mockDiSetup();

        final repository = getIt<WeatherRepository>();
        expect(repository, isNotNull);
        expect(repository, isA<WeatherRepository>());
      });

      testWidgets('LocationRepository가 올바르게 주입되어야 한다', (tester) async {
        mockDiSetup();

        final repository = getIt<LocationRepository>();
        expect(repository, isNotNull);
        expect(repository, isA<LocationRepository>());
      });

      testWidgets('GetCurrentWeatherUseCase가 올바르게 주입되어야 한다', (tester) async {
        mockDiSetup();

        final useCase = getIt<GetCurrentWeatherUseCase>();
        expect(useCase, isNotNull);
        expect(useCase, isA<GetCurrentWeatherUseCase>());
      });

      testWidgets('GetCurrentLocationUseCase가 올바르게 주입되어야 한다', (tester) async {
        mockDiSetup();

        final useCase = getIt<GetCurrentLocationUseCase>();
        expect(useCase, isNotNull);
        expect(useCase, isA<GetCurrentLocationUseCase>());
      });
    });

    group('3. 라우팅 - 온보딩 → 홈', () {
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

      testWidgets('온보딩 완료 시 홈 화면이 표시되어야 한다', (tester) async {
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

      testWidgets('온보딩에서 홈으로 네비게이션이 동작해야 한다', (tester) async {
        mockDiSetup();

        await tester.pumpWidget(
          const ProviderScope(
            child: MyApp(onboardingComplete: false),
          ),
        );
        await tester.pumpAndSettle();

        // 1단계: "시작하기" 탭
        await tester.tap(find.text('시작하기'));
        await tester.pumpAndSettle();

        // 2단계: "위치 정보 허용하기" 탭
        await tester.tap(find.text('위치 정보 허용하기'));
        await tester.pumpAndSettle();

        expect(find.byType(PageView), findsNothing);
      });
    });

    group('4. 라우팅 - 홈 → 온도 검색', () {
      testWidgets('홈에서 온도 검색 화면으로 이동할 수 있어야 한다', (tester) async {
        mockDiSetup();

        await tester.pumpWidget(
          const ProviderScope(
            child: MyApp(onboardingComplete: true),
          ),
        );
        await tester.pumpAndSettle();

        await tester.tap(find.byIcon(Icons.search_rounded));
        await tester.pumpAndSettle();

        expect(find.text('온도로 옷차림 찾기'), findsOneWidget);
      });

      testWidgets('온도 검색에서 뒤로가기로 홈에 돌아올 수 있어야 한다', (tester) async {
        mockDiSetup();

        await tester.pumpWidget(
          const ProviderScope(
            child: MyApp(onboardingComplete: true),
          ),
        );
        await tester.pumpAndSettle();

        await tester.tap(find.byIcon(Icons.search_rounded));
        await tester.pumpAndSettle();

        await tester.tap(find.byIcon(Icons.arrow_back_rounded));
        await tester.pumpAndSettle();

        expect(find.text('온도로 옷차림 찾기'), findsNothing);
        expect(find.byIcon(Icons.search_rounded), findsOneWidget);
      });
    });

    group('5. 라우팅 - 화면 전환 일관성', () {
      testWidgets('여러 번 화면 전환이 일관되게 동작해야 한다', (tester) async {
        mockDiSetup();

        await tester.pumpWidget(
          const ProviderScope(
            child: MyApp(onboardingComplete: true),
          ),
        );
        await tester.pumpAndSettle();

        for (int i = 0; i < 3; i++) {
          await tester.tap(find.byIcon(Icons.search_rounded));
          await tester.pumpAndSettle();
          expect(find.text('온도로 옷차림 찾기'), findsOneWidget);

          await tester.tap(find.byIcon(Icons.arrow_back_rounded));
          await tester.pumpAndSettle();
          expect(find.byIcon(Icons.search_rounded), findsOneWidget);
        }
      });
    });

    group('6. 화면 전환 시 상태 유지', () {
      testWidgets('홈 화면 데이터가 화면 전환 후에도 유지되어야 한다', (tester) async {
        mockDiSetup();

        await tester.pumpWidget(
          const ProviderScope(
            child: MyApp(onboardingComplete: true),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.textContaining('서울특별시'), findsOneWidget);

        await tester.tap(find.byIcon(Icons.search_rounded));
        await tester.pumpAndSettle();
        await tester.tap(find.byIcon(Icons.arrow_back_rounded));
        await tester.pumpAndSettle();

        expect(find.textContaining('서울특별시'), findsOneWidget);
      });
    });

    group('7. DI 리셋 테스트', () {
      testWidgets('DI 리셋 후 재등록이 가능해야 한다', (tester) async {
        mockDiSetup();
        expect(getIt.isRegistered<WeatherDataSourceInterface>(), isTrue);

        resetMockDi();
        expect(getIt.isRegistered<WeatherDataSourceInterface>(), isFalse);

        mockDiSetup();
        expect(getIt.isRegistered<WeatherDataSourceInterface>(), isTrue);
      });
    });

    group('8. 앱 생명주기와 DI', () {
      testWidgets('앱 재시작 시 DI가 올바르게 동작해야 한다', (tester) async {
        mockDiSetup();

        await tester.pumpWidget(
          const ProviderScope(
            child: MyApp(onboardingComplete: true),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.byIcon(Icons.search_rounded), findsOneWidget);

        await tester.pumpWidget(
          const ProviderScope(
            child: MyApp(onboardingComplete: true),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.byIcon(Icons.search_rounded), findsOneWidget);
      });
    });

    group('9. ProviderScope 테스트', () {
      testWidgets('ProviderScope가 올바르게 설정되어야 한다', (tester) async {
        mockDiSetup();

        await tester.pumpWidget(
          const ProviderScope(
            child: MyApp(onboardingComplete: true),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.byType(Scaffold), findsOneWidget);
      });
    });

    group('10. 라우트 파라미터 테스트', () {
      testWidgets('onboardingComplete 파라미터가 라우팅에 영향을 미쳐야 한다', (tester) async {
        mockDiSetup();

        // Test 1: false인 경우
        await tester.pumpWidget(
          const ProviderScope(
            child: MyApp(onboardingComplete: false),
          ),
        );
        await tester.pumpAndSettle();
        expect(find.byType(PageView), findsOneWidget);

        // Test 2: true인 경우
        await tester.pumpWidget(
          const ProviderScope(
            child: MyApp(onboardingComplete: true),
          ),
        );
        await tester.pumpAndSettle();
        expect(find.byType(PageView), findsNothing);
      });
    });
  });
}
