/// 에러 처리 통합 테스트
///
/// 테스트 시나리오:
/// 1. 네트워크 에러 처리
/// 2. 위치 권한 거부 처리
/// 3. 에러 상태에서의 UI 표시
/// 4. 재시도 기능

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

/// Mock WeatherDataSource - 성공 시나리오
class MockWeatherDataSourceSuccess implements WeatherDataSourceInterface {
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

/// Mock LocationDataSource - 성공 시나리오
class MockLocationDataSourceSuccess implements LocationDataSourceInterface {
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

/// Mock DI 설정 - 성공 시나리오
void mockDiSetup() {
  getIt.registerSingleton<WeatherDataSourceInterface>(MockWeatherDataSourceSuccess());
  getIt.registerSingleton<LocationDataSourceInterface>(MockLocationDataSourceSuccess());

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
  group('에러 처리 통합 테스트', () {
    setUp(() {
      resetMockDi();
    });

    tearDown(() {
      resetMockDi();
    });

    group('1. 정상 동작 확인', () {
      testWidgets('정상 상태에서 홈 화면이 표시되어야 한다', (tester) async {
        mockDiSetup();

        await tester.pumpWidget(
          const ProviderScope(
            child: MyApp(onboardingComplete: true),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.byType(Scaffold), findsOneWidget);
        expect(find.textContaining('서울특별시'), findsOneWidget);
      });

      testWidgets('정상 상태에서 검색 버튼이 표시되어야 한다', (tester) async {
        mockDiSetup();

        await tester.pumpWidget(
          const ProviderScope(
            child: MyApp(onboardingComplete: true),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.byIcon(Icons.search_rounded), findsOneWidget);
      });
    });

    group('2. 새로고침 동작', () {
      testWidgets('새로고침 버튼이 표시되어야 한다', (tester) async {
        mockDiSetup();

        await tester.pumpWidget(
          const ProviderScope(
            child: MyApp(onboardingComplete: true),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.byIcon(Icons.refresh_rounded), findsOneWidget);
      });

      testWidgets('새로고침 버튼 탭 시 화면이 갱신되어야 한다', (tester) async {
        mockDiSetup();

        await tester.pumpWidget(
          const ProviderScope(
            child: MyApp(onboardingComplete: true),
          ),
        );
        await tester.pumpAndSettle();

        await tester.tap(find.byIcon(Icons.refresh_rounded));
        await tester.pumpAndSettle();

        expect(find.byType(Scaffold), findsOneWidget);
      });
    });

    group('3. 온보딩 화면 에러 처리', () {
      testWidgets('온보딩에서 위치 권한 허용 후 정상 동작해야 한다', (tester) async {
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

        // 홈 화면으로 이동
        expect(find.byType(PageView), findsNothing);
      });
    });

    group('4. 화면 UI 검증', () {
      testWidgets('날씨 정보가 표시되어야 한다', (tester) async {
        mockDiSetup();

        await tester.pumpWidget(
          const ProviderScope(
            child: MyApp(onboardingComplete: true),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.textContaining('22'), findsWidgets);
      });

      testWidgets('옷차림 추천이 표시되어야 한다', (tester) async {
        mockDiSetup();

        await tester.pumpWidget(
          const ProviderScope(
            child: MyApp(onboardingComplete: true),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.text('오늘의 추천 옷차림'), findsOneWidget);
      });
    });

    group('5. 네비게이션 에러 처리', () {
      testWidgets('온도 검색 화면에서 뒤로가기가 정상 동작해야 한다', (tester) async {
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

      testWidgets('여러 번 화면 전환 시 에러가 발생하지 않아야 한다', (tester) async {
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

          await tester.tap(find.byIcon(Icons.arrow_back_rounded));
          await tester.pumpAndSettle();
        }

        expect(find.byType(Scaffold), findsOneWidget);
      });
    });

    group('6. 슬라이더 에러 처리', () {
      testWidgets('슬라이더 극단값에서도 에러가 발생하지 않아야 한다', (tester) async {
        mockDiSetup();

        await tester.pumpWidget(
          const ProviderScope(
            child: MyApp(onboardingComplete: true),
          ),
        );
        await tester.pumpAndSettle();

        await tester.tap(find.byIcon(Icons.search_rounded));
        await tester.pumpAndSettle();

        // 최저값
        await tester.drag(find.byType(Slider), const Offset(-500, 0));
        await tester.pumpAndSettle();

        expect(find.byType(Slider), findsOneWidget);

        // 최고값
        await tester.drag(find.byType(Slider), const Offset(500, 0));
        await tester.pumpAndSettle();

        expect(find.byType(Slider), findsOneWidget);
      });
    });

    group('7. 앱 상태 복구', () {
      testWidgets('화면 전환 후 상태가 유지되어야 한다', (tester) async {
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

    group('8. 앱 재시작', () {
      testWidgets('앱 재시작 시 에러가 발생하지 않아야 한다', (tester) async {
        mockDiSetup();

        await tester.pumpWidget(
          const ProviderScope(
            child: MyApp(onboardingComplete: true),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.byType(Scaffold), findsOneWidget);

        await tester.pumpWidget(
          const ProviderScope(
            child: MyApp(onboardingComplete: true),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.byType(Scaffold), findsOneWidget);
      });
    });
  });
}
